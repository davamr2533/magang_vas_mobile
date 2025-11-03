import 'package:json_annotation/json_annotation.dart';

part 'get_data_vas_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GetDataVasBody {
  String? nomorAjuan;

  GetDataVasBody({this.nomorAjuan});

  GetDataVasBody.fromJson(Map<String, dynamic> json) {
    nomorAjuan = json['nomor_ajuan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nomor_ajuan'] = this.nomorAjuan;
    return data;
  }
}