// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'starred_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StarredBody _$StarredBodyFromJson(Map<String, dynamic> json) => StarredBody(
  id: (json['id'] as num?)?.toInt(),
  userId: json['user_id'] as String?,
  starred: json['starred'] as bool?,
  name: json['name'] as String?,
  itemType: json['item_type'] as String?,
);

Map<String, dynamic> _$StarredBodyToJson(StarredBody instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'starred': instance.starred,
      'name': instance.name,
      'item_type': instance.itemType,
    };
