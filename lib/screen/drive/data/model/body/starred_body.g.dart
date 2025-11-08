// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'starred_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StarredBody _$StarredBodyFromJson(Map<String, dynamic> json) => StarredBody(
  userId: json['user_id'] as String?,
  folderId: (json['folder_id'] as num?)?.toInt(),
  fileId: (json['file_id'] as num?)?.toInt(),
  isStarred: json['is_starred'] as String?,
);

Map<String, dynamic> _$StarredBodyToJson(StarredBody instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'folder_id': instance.folderId,
      'file_id': instance.fileId,
      'is_starred': instance.isStarred,
    };
