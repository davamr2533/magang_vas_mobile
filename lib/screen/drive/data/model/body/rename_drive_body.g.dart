// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rename_drive_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenameDriveBody _$RenameDriveBodyFromJson(Map<String, dynamic> json) =>
    RenameDriveBody(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      itemType: json['item_type'] as String?,
    );

Map<String, dynamic> _$RenameDriveBodyToJson(RenameDriveBody instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'item_type': instance.itemType,
    };
