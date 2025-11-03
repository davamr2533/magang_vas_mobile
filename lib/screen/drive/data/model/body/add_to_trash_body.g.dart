// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_trash_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToTrashBody _$AddToTrashBodyFromJson(Map<String, dynamic> json) =>
    AddToTrashBody(
      id: (json['id'] as num?)?.toInt(),
      isTrashed: json['is_trashed'] as String? ?? "TRUE",
      userId: json['user_id'] as String?,
      itemType: json['item_type'] as String?,
    );

Map<String, dynamic> _$AddToTrashBodyToJson(AddToTrashBody instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'is_trashed': instance.isTrashed,
      'item_type': instance.itemType,
    };
