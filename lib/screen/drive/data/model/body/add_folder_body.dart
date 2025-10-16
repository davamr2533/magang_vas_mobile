import 'package:json_annotation/json_annotation.dart';

part 'add_folder_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddFolderBody {
  int? parentId;
  String? userId;
  String? nameFolder;

  AddFolderBody({
    this.parentId,
    this.userId,
    this.nameFolder,
  });

  AddFolderBody.fromJson(Map<String, dynamic> json) {
    parentId = json['parent_id'];
    userId = json['user_id'];
    nameFolder = json['name_folder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parent_id'] = this.parentId;
    data['user_id'] = this.userId;
    data['name_folder'] = this.nameFolder;
    return data;
  }
}
