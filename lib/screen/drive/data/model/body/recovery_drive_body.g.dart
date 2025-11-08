// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_drive_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryDriveBody _$RecoveryDriveBodyFromJson(Map<String, dynamic> json) =>
    RecoveryDriveBody(
      userId: json['user_id'] as String?,
      folderId: (json['folder_id'] as num?)?.toInt(),
      fileId: (json['file_id'] as num?)?.toInt(),
      isTrashed: json['is_trashed'] as String?,
    );

Map<String, dynamic> _$RecoveryDriveBodyToJson(RecoveryDriveBody instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'folder_id': instance.folderId,
      'file_id': instance.fileId,
      'is_trashed': instance.isTrashed,
    };
