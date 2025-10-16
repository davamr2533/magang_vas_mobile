import 'package:json_annotation/json_annotation.dart';

part 'add_folder_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AddFolderResponse {
  String? status;
  String? message;

  AddFolderResponse({this.status, this.message});

  AddFolderResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }

}
