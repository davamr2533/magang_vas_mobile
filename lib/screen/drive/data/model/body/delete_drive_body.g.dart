// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_drive_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteDriveBody _$DeleteDriveBodyFromJson(Map<String, dynamic> json) =>
    DeleteDriveBody(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      itemType: json['item_type'] as String?,
    );

Map<String, dynamic> _$DeleteDriveBodyToJson(DeleteDriveBody instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'item_type': instance.itemType,
    };
