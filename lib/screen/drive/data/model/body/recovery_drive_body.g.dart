// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_drive_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryDriveBody _$RecoveryDriveBodyFromJson(Map<String, dynamic> json) =>
    RecoveryDriveBody(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      itemType: json['item_type'] as String?,
    );

Map<String, dynamic> _$RecoveryDriveBodyToJson(RecoveryDriveBody instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'item_type': instance.itemType,
    };
