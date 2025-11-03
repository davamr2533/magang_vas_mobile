import 'package:json_annotation/json_annotation.dart';

part 'form_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FormResponse {
  String? status;
  String? message;

  FormResponse({this.status, this.message});

  FormResponse.fromJson(Map<String, dynamic> json) {
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
