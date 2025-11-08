import 'package:json_annotation/json_annotation.dart';
import 'package:vas_reporting/screen/drive/drive_item_model.dart';

part 'delete_drive_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DeleteDriveBody {
  String? userId;
  int? folderId;
  int? fileId;

  DeleteDriveBody({
    this.userId, this.folderId, this.fileId
  });

  factory DeleteDriveBody.fromJson(Map<String, dynamic> json) => DeleteDriveBody(
    userId: json['user_id'] as String?,
    folderId: json['folder_id'] as int?,
    fileId: json['file_id'] as int?,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['folder_id'] = folderId;
    data['file_id'] = fileId;
    return data;
  }
}
