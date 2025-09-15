import 'package:json_annotation/json_annotation.dart';

part 'form_ajuan_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FormAjuanBody {
  String? nama;
  String? divisi;
  String? sistem;
  String? jenis;
  String? anggaran;
  String? masalah;
  String? output;

  FormAjuanBody(
      {this.nama,
      this.divisi,
      this.sistem,
      this.jenis,
      this.anggaran,
      this.masalah,
      this.output});

  FormAjuanBody.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    divisi = json['divisi'];
    sistem = json['sistem'];
    jenis = json['jenis'];
    anggaran = json['anggaran'];
    masalah = json['masalah'];
    output = json['output'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama'] = this.nama;
    data['divisi'] = this.divisi;
    data['sistem'] = this.sistem;
    data['jenis'] = this.jenis;
    data['anggaran'] = this.anggaran;
    data['masalah'] = this.masalah;
    data['output'] = this.output;
    return data;
  }
}
