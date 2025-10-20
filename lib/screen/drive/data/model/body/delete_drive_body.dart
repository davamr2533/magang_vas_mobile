import 'package:json_annotation/json_annotation.dart';
import 'package:vas_reporting/screen/drive/drive_item_model.dart';

part 'delete_drive_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DeleteDriveBody {
  int? id;
  String? name;
  String? itemType;

  DeleteDriveBody({
    this.id,
    this.name,
    this.itemType
  });

  DeleteDriveBody.fromJson(Map<String, dynamic> json) {
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
