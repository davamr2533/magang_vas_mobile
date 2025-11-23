// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rename_drive_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenameDriveBody _$RenameDriveBodyFromJson(Map<String, dynamic> json) =>
    RenameDriveBody(
      name: json['name'] as String?,
      folderId: (json['folder_id'] as num?)?.toInt(),
      fileId: (json['file_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RenameDriveBodyToJson(RenameDriveBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'folder_id': instance.folderId,
      'file_id': instance.fileId,
    };
