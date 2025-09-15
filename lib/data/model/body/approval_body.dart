import 'package:json_annotation/json_annotation.dart';

part 'approval_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ApprovalBody {
  String? id;
  String? status;
  String? nama;

  ApprovalBody({this.id, this.status, this.nama});

  ApprovalBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['nama'] = this.nama;
    return data;
  }
}
