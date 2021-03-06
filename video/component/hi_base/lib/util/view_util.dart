import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/util/color.dart';
import 'package:hi_base/util/format_util.dart';

/// 图片本地缓存
Widget cacheNetworkImage(String url, {double? height, double? width}) {
  return url.isEmpty
      ? Container(
          color: Colors.grey,
        )
      : CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: width,
          height: height,
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(color: Colors.grey),
            child: Icon(
              Icons.local_dining,
              color: Colors.white,
              size: 10,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(color: Colors.grey),
            child: Icon(
              Icons.error,
              color: Colors.white,
              size: 10,
            ),
          ),
        );
}

/// 黑色线性渐变
LinearGradient blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent,
      ]);
}

smallIconText(IconData iconData, var text) {
  var style = TextStyle(fontSize: 12, color: Colors.grey);
  if (text is int) {
    text = countFormat(text);
  }
  return [
    Icon(
      iconData,
      color: Colors.grey,
      size: 12,
    ),
    hiSpace(width: 3),
    Text(
      '$text',
      style: style,
    )
  ];
}

borderLine(BuildContext context, {bottom: true, top: false}) {
  BorderSide borderSide =
      BorderSide(width: 0.5, color: Colors.grey[200] ?? primary);
  return Border(
      bottom: bottom ? borderSide : BorderSide.none,
      top: top ? borderSide : BorderSide.none);
}

SizedBox hiSpace({double height: 1, double width: 1}) {
  return SizedBox(
    height: height,
    width: width,
  );
}
