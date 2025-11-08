import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'starred_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StarredBody {
  String? userId;
  int? folderId;
  int? fileId;
  String? isStarred;

  StarredBody({this.userId, this.folderId, this.fileId, this.isStarred});

  factory StarredBody.fromJson(Map<String, dynamic> json) => StarredBody(
    userId: json['user_id'] as String?,
    folderId: json['folder_id'] as int?,
    fileId: json['file_id'] as int?,
    isStarred: json['is_starred'] as String?,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['folder_id'] = folderId;
    data['file_id'] = fileId;
    data['is_starred'] = isStarred;
    return data;
  }
}
