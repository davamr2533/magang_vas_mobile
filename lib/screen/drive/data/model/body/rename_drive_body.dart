import 'package:json_annotation/json_annotation.dart';
import 'package:vas_reporting/screen/drive/drive_item_model.dart';

part 'rename_drive_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RenameDriveBody {
  String? name;
  int? folderId;
  int? fileId;

  RenameDriveBody({
    this.name,
    this.folderId,
    this.fileId
  });

  factory RenameDriveBody.fromJson(Map<String, dynamic> json) => RenameDriveBody(
    name: json['name'] as String?,
    folderId: json['folder_id'] as int?,
    fileId: json['file_id'] as int?,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['folder_id'] = folderId;
    data['file_id'] = fileId;
    return data;
  }
}
