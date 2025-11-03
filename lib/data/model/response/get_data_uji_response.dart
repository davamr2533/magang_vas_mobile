import 'package:json_annotation/json_annotation.dart';

part 'get_data_uji_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GetDataUjiResponse {
  String? status;
  String? message;
  List<Data>? data;

  GetDataUjiResponse({this.status, this.message, this.data});

  GetDataUjiResponse.fromJson(Map<String, dynamic> json) {
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
  String? nomorPengajuan;
  List<Detail>? detail;

  Data({this.nomorPengajuan, this.detail});

  Data.fromJson(Map<String, dynamic> json) {
    nomorPengajuan = json['nomor_pengajuan'];
    if (json['detail'] != null) {
      detail = <Detail>[];
      json['detail'].forEach((v) {
        detail!.add(new Detail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nomor_pengajuan'] = this.nomorPengajuan;
    if (this.detail != null) {
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  int? id;
  String? nomorPengajuan;
  String? perangkatLunak;
  String? versi;
  String? tujuan;
  String? metode;
  String? namaUji;
  String? kasusUji;
  String? hasilHarapan;
  String? hasilUji;
  String? keterangan;
  String? createdAt;

  Detail(
      {this.id,
      this.nomorPengajuan,
      this.perangkatLunak,
      this.versi,
      this.tujuan,
      this.metode,
      this.namaUji,
      this.kasusUji,
      this.hasilHarapan,
      this.hasilUji,
      this.keterangan,
      this.createdAt});

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomorPengajuan = json['nomor_pengajuan'];
    perangkatLunak = json['perangkat_lunak'];
    versi = json['versi'];
    tujuan = json['tujuan'];
    metode = json['metode'];
    namaUji = json['nama_uji'];
    kasusUji = json['kasus_uji'];
    hasilHarapan = json['hasil_harapan'];
    hasilUji = json['hasil_uji'];
    keterangan = json['keterangan'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nomor_pengajuan'] = this.nomorPengajuan;
    data['perangkat_lunak'] = this.perangkatLunak;
    data['versi'] = this.versi;
    data['tujuan'] = this.tujuan;
    data['metode'] = this.metode;
    data['nama_uji'] = this.namaUji;
    data['kasus_uji'] = this.kasusUji;
    data['hasil_harapan'] = this.hasilHarapan;
    data['hasil_uji'] = this.hasilUji;
    data['keterangan'] = this.keterangan;
    data['created_at'] = this.createdAt;
    return data;
  }
}
