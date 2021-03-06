import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video/navigator/bottom_navigator.dart';
import 'package:video/page/login_page.dart';
import 'package:video/page/notice_page.dart';
import 'package:video/page/register_page.dart';
import 'package:video/page/video_detail_page.dart';
import 'package:video/wiget/theme_page.dart';

typedef RouteChangeListener(RouteStatusInfo current, RouteStatusInfo? pre);

/// 创建页面
pageWrap(Widget child) {
  return MaterialPage(child: child, key: ValueKey(child.hashCode));
}

/// 自定义路由状态，路由状态
enum RouteStatus { login, register, home, detail, notice, theme, unkown }

/// 获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegisterPage) {
    return RouteStatus.register;
  } else if (page.child is BottomNavigator) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else if (page.child is NoticePage) {
    return RouteStatus.notice;
  } else if (page.child is ThemePage) {
    return RouteStatus.theme;
  }

  return RouteStatus.unkown;
}

/// 路由信息
class RouteStatusInfo {
  RouteStatus routeStatus;
  Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

/// 获取RouteStatus在页面堆栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (var i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

/// 监听路由跳转，监听当前页面是否压后台
class HiNavigator extends _RouteJumpListener {
  static HiNavigator? _instance;
  HiNavigator._();
  static HiNavigator getInstance() {
    if (_instance == null) {
      _instance = HiNavigator._();
    }
    return _instance!;
  }

  RouteStatusInfo? get current => _current;

  /// 跳转监听
  RouteJumpListener? _routeJump;

  /// 路由变化监听
  List<RouteChangeListener> _listeners = [];

  /// 打开过的页面
  RouteStatusInfo? _current;

  /// 首页底部tab
  RouteStatusInfo? _bottomTab;

  /// 跳转某个链接
  Future<bool> launchUrl(String url) async {
    var result = await canLaunch(url);
    if (result) {
      return await launch(url);
    } else {
      return Future.value(false);
    }
  }

  /// 首页底部tab切换监听
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab!);
  }

  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      this._listeners.add(listener);
    }
  }

  void removeListener(RouteChangeListener? listener) {
    this._listeners.remove(listener);
  }

  /// 通知路由页面路由变化
  void notify(List<MaterialPage> currentPage, List<MaterialPage> prePages) {
    if (currentPage == prePages) return;

    var current =
        RouteStatusInfo(getStatus(currentPage.last), currentPage.last.child);

    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    //如果打开的是首页，则明确到首页具体的tab
    if (current.page is BottomNavigator && _bottomTab != null) {
      current = _bottomTab!;
    }

    printLog("当前页面:${current.page}");
    printLog("打开过的页面:${_current?.page}");

    _listeners.forEach((element) {
      element(current, _current);
    });
    _current = current;
  }

  void registerRouteJump(RouteJumpListener routeJumpListener) {
    this._routeJump = routeJumpListener;
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    if (_routeJump?.onJumpTo != null) {
      _routeJump!.onJumpTo!(routeStatus, args: args);
    }
  }
}

/// 抽象类供HiNavigator实现
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map? args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

class RouteJumpListener {
  OnJumpTo? onJumpTo;
  RouteJumpListener({this.onJumpTo});
}

printLog(String text) {
  print("HiNavigator-$text");
}


// parser是web用来做路由的，不需要可以去掉，parser和provider是成对出现的
// class BRouterParser extends RouteInformationParser<BRoutePath> {
//   @override
//   Future<BRoutePath> parseRouteInformation(
//       RouteInformation routeInformation) async {
//     final uri = Uri.parse(routeInformation.location ?? '');
//     print("跳转地址:$uri");
//     if (uri.pathSegments.length == 0) {
//       return BRoutePath.home();
//     } else {
//       return BRoutePath.detail();
//     }
//   }
// }


// /// PopNavigatorRouterDelegateMixin里面实现了popRoute，可以不用重写实现RouterDelegate里面的popRoute
// /// ChangeNotifier里面实现了addListener,removeListener，可以不用重写实现RouterDelegate里面的addListener,removeListener
// class BRouteDelegate extends RouterDelegate<BRoutePath>
//     with ChangeNotifier, PopNavigatorRouterDelegateMixin {
//   final GlobalKey<NavigatorState> navigationKey;
//   // 为navigator设置一个key，必要的时候可以通过navigationKey.currentState来获取NavigatorState对象，pop,canPop,push等
//   BRouteDelegate() : navigationKey = GlobalKey<NavigatorState>();

//   BRoutePath? path;

//   List<MaterialPage> pages = [];

//   Video? video;

//   @override
//   Widget build(BuildContext context) {
//     //路由堆栈
//     pages = [
//       pageWrap(HomePage(
//         onJumpDetail: (video) {
//           this.video = video;
//           this.notifyListeners();
//         },
//       )),
//       if (video != null) pageWrap(VideoDetailPage(video!)),
//     ];

//     return Navigator(
//       key: navigationKey,
//       pages: pages,
//       onPopPage: (route, result) {
//         //控制是否能返回
//         if (!route.didPop(result)) {
//           return false;
//         }
//         return true;
//       },
//     );
//   }

//   @override
//   Future<void> setNewRoutePath(BRoutePath configuration) async {
//     this.path = configuration;
//   }

//   @override
//   GlobalKey<NavigatorState>? get navigatorKey => navigationKey;
// }
