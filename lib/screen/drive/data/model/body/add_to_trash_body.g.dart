// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_trash_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToTrashBody _$AddToTrashBodyFromJson(Map<String, dynamic> json) =>
    AddToTrashBody(
      userId: json['user_id'] as String?,
      folderId: (json['folder_id'] as num?)?.toInt(),
      fileId: (json['file_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AddToTrashBodyToJson(AddToTrashBody instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'folder_id': instance.folderId,
      'file_id': instance.fileId,
    };
