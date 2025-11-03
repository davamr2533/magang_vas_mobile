import 'package:json_annotation/json_annotation.dart';
import 'package:vas_reporting/screen/drive/drive_item_model.dart';

part 'add_to_trash_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddToTrashBody {
  int? id;
  String? userId;
  String? isTrashed;
  String? itemType;

  AddToTrashBody({
    this.id,
    this.isTrashed = "TRUE",
    this.userId,
    this.itemType
  });

  AddToTrashBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    itemType = json['item_type'];
    isTrashed = json['is_trashed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['item_type'] = itemType;
    data['is_trashed'] = isTrashed;
    return data;
  }
}
