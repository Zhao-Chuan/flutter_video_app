// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ownerModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnerModel _$OwnerModelFromJson(Map<String, dynamic> json) => OwnerModel(
      face: json['face'] as String? ?? "",
      name: json['name'] as String? ?? "",
      fans: json['fans'] as int? ?? 0,
    );

Map<String, dynamic> _$OwnerModelToJson(OwnerModel instance) =>
    <String, dynamic>{
      'face': instance.face,
      'name': instance.name,
      'fans': instance.fans,
    };
