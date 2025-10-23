import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'starred_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StarredBody {
  int? id;
  String? userId;
  bool? starred;
  String? name;
  String? itemType;

  StarredBody({
    this.id,
    this.userId,
    this.starred,
    this.name,
    this.itemType
  });

  factory StarredBody.fromJson(Map<String, dynamic> json) => StarredBody(
    id: json['id'] as int?,
    userId: json['user_id'] as String?,
    starred: json['is_starred'] is String
        ? (json['is_starred'].toString().toUpperCase() == 'TRUE')
        : json['is_starred'] as bool?,
    name: json['name'],
    itemType: json['item_type']

  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['is_starred'] = starred != null ? (starred! ? 'TRUE' : 'FALSE') : null;
    data['name'] = name;
    data['item_type'] = itemType;
    return data;
  }


}
