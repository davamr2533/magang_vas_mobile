import 'package:json_annotation/json_annotation.dart';
import 'package:vas_reporting/screen/drive/drive_item_model.dart';

part 'rename_drive_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RenameDriveBody {
  int? id;
  String? name;
  String? itemType;

  RenameDriveBody({
    this.id,
    this.name,
    this.itemType
  });

  RenameDriveBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    itemType = json['item_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['item_type'] = itemType;
    return data;
  }
}
