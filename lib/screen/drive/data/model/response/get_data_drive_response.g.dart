// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_data_drive_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDataDriveResponse _$GetDataDriveResponseFromJson(
  Map<String, dynamic> json,
) => GetDataDriveResponse(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => FolderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetDataDriveResponseToJson(
  GetDataDriveResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data?.map((e) => e.toJson()).toList(),
};

FolderItem _$FolderItemFromJson(Map<String, dynamic> json) => FolderItem(
  id: (json['id'] as num?)?.toInt(),
  parentId: (json['parent_id'] as num?)?.toInt(),
  userId: json['user_id'] as String?,
  name: json['name'] as String?,
  isStarred: json['is_starred'] as String?,
  isTrashed: json['is_trashed'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  children: (json['children'] as List<dynamic>?)
      ?.map((e) => FolderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  files: (json['files'] as List<dynamic>?)
      ?.map((e) => FileItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FolderItemToJson(FolderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'user_id': instance.userId,
      'name': instance.name,
      'is_starred': instance.isStarred,
      'is_trashed': instance.isTrashed,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'children': instance.children?.map((e) => e.toJson()).toList(),
      'files': instance.files?.map((e) => e.toJson()).toList(),
    };

FileItem _$FileItemFromJson(Map<String, dynamic> json) => FileItem(
  id: (json['id'] as num?)?.toInt(),
  parentId: (json['parent_id'] as num?)?.toInt(),
  userId: json['user_id'] as String?,
  name: json['name'] as String?,
  mimeType: json['mime_type'] as String?,
  size: json['size'] as String?,
  urlFile: json['url_file'] as String?,
  isStarred: json['is_starred'] as String?,
  isTrashed: json['is_trashed'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$FileItemToJson(FileItem instance) => <String, dynamic>{
  'id': instance.id,
  'parent_id': instance.parentId,
  'user_id': instance.userId,
  'name': instance.name,
  'mime_type': instance.mimeType,
  'size': instance.size,
  'url_file': instance.urlFile,
  'is_starred': instance.isStarred,
  'is_trashed': instance.isTrashed,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
