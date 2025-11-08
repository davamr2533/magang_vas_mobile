// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_drive_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteDriveBody _$DeleteDriveBodyFromJson(Map<String, dynamic> json) =>
    DeleteDriveBody(
      userId: json['user_id'] as String?,
      folderId: (json['folder_id'] as num?)?.toInt(),
      fileId: (json['file_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DeleteDriveBodyToJson(DeleteDriveBody instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'folder_id': instance.folderId,
      'file_id': instance.fileId,
    };
