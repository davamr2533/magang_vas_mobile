// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_folder_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddFolderBody _$AddFolderBodyFromJson(Map<String, dynamic> json) =>
    AddFolderBody(
      parentId: (json['parent_id'] as num?)?.toInt(),
      userId: json['user_id'] as String?,
      nameFolder: json['name_folder'] as String?,
    );

Map<String, dynamic> _$AddFolderBodyToJson(AddFolderBody instance) =>
    <String, dynamic>{
      'parent_id': instance.parentId,
      'user_id': instance.userId,
      'name_folder': instance.nameFolder,
    };
