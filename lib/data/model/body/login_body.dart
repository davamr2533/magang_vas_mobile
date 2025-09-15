import 'package:json_annotation/json_annotation.dart';

part 'login_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginBody {
  String? username;
  String? passwordKey;

  LoginBody({this.username, this.passwordKey});

  LoginBody.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    passwordKey = json['password_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password_key'] = this.passwordKey;
    return data;
  }
}
