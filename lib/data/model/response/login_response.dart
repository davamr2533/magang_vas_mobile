import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponse {
  String? status;
  String? message;
  String? token;
  Customer? customer;

  LoginResponse({this.status, this.message, this.token, this.customer});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class Customer {
  String? nama;
  String? username;
  int? flag;
  String? jeniskelamin;
  String? divisi;
  String? jabatan;

  Customer(
      {this.nama,
      this.username,
      this.flag,
      this.jeniskelamin,
      this.divisi,
      this.jabatan});

  Customer.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    username = json['username'];
    flag = json['flag'];
    jeniskelamin = json['jeniskelamin'];
    divisi = json['divisi'];
    jabatan = json['jabatan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama'] = this.nama;
    data['username'] = this.username;
    data['flag'] = this.flag;
    data['jeniskelamin'] = this.jeniskelamin;
    data['divisi'] = this.divisi;
    data['jabatan'] = this.jabatan;
    return data;
  }
}
