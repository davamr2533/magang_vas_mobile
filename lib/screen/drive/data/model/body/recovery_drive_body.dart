import 'package:json_annotation/json_annotation.dart';
import 'package:vas_reporting/screen/drive/drive_item_model.dart';

part 'recovery_drive_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RecoveryDriveBody {
  String? userId;
  int? folderId;
  int? fileId;
  String? isTrashed;


  RecoveryDriveBody({this.userId, this.folderId, this.fileId, this.isTrashed});

  factory RecoveryDriveBody.fromJson(Map<String, dynamic> json) => RecoveryDriveBody(
    userId: json['user_id'] as String?,
    folderId: json['folder_id'] as int?,
    fileId: json['file_id'] as int?,
    isTrashed: json['is_trashed'] as String?,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['folder_id'] = folderId;
    data['file_id'] = fileId;
    data['is_trashed'] = isTrashed;
    return data;
  }
}
