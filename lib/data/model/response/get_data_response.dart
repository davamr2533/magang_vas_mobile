import 'package:json_annotation/json_annotation.dart';

part 'get_data_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GetDataResponse {
  String? status;
  String? message;
  List<Data>? data;

  GetDataResponse({this.status, this.message, this.data});

  GetDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? namaPemohon;
  String? divisi;
  String? sistem;
  String? jenis;
  String? rencanaAnggaran;
  String? masalah;
  String? output;
  String? createdAt;
  String? approvedBy;
  String? statusAjuan;
  String? nomorPengajuan;

  Data(
      {this.id,
      this.namaPemohon,
      this.divisi,
      this.sistem,
      this.jenis,
      this.rencanaAnggaran,
      this.masalah,
      this.output,
      this.createdAt,
      this.approvedBy,
      this.statusAjuan,
      this.nomorPengajuan});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaPemohon = json['nama_pemohon'];
    divisi = json['divisi'];
    sistem = json['sistem'];
    jenis = json['jenis'];
    rencanaAnggaran = json['rencana_anggaran'];
    masalah = json['masalah'];
    output = json['output'];
    createdAt = json['created_at'];
    approvedBy = json['approved_by'];
    statusAjuan = json['status_ajuan'];
    nomorPengajuan = json['nomor_pengajuan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_pemohon'] = this.namaPemohon;
    data['divisi'] = this.divisi;
    data['sistem'] = this.sistem;
    data['jenis'] = this.jenis;
    data['rencana_anggaran'] = this.rencanaAnggaran;
    data['masalah'] = this.masalah;
    data['output'] = this.output;
    data['created_at'] = this.createdAt;
    data['approved_by'] = this.approvedBy;
    data['status_ajuan'] = this.statusAjuan;
    data['nomor_pengajuan'] = this.nomorPengajuan;
    return data;
  }
}
