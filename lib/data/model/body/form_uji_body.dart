import 'package:json_annotation/json_annotation.dart';

part 'form_uji_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FormUjiBody {
  String? status;
  String? nomor;
  String? perangkatLunak;
  String? versi;
  String? tujuan;
  String? metode;
  String? namaUji;
  String? kasusUji;
  String? hasilHarapan;
  String? hasilUji;
  String? keterangan;
  String? jenis;
  String? divisi;

  FormUjiBody(
      {this.status,
      this.nomor,
      this.perangkatLunak,
      this.versi,
      this.tujuan,
      this.metode,
      this.namaUji,
      this.kasusUji,
      this.hasilHarapan,
      this.hasilUji,
      this.keterangan,
      this.jenis,
      this.divisi
      });

  FormUjiBody.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    nomor = json['nomor'];
    perangkatLunak = json['perangkatLunak'];
    versi = json['versi'];
    tujuan = json['tujuan'];
    metode = json['metode'];
    namaUji = json['namaUji'];
    kasusUji = json['kasusUji'];
    hasilHarapan = json['hasilHarapan'];
    hasilUji = json['hasilUji'];
    keterangan = json['keterangan'];
    jenis = json['jenis'];
    divisi = json['divisi'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['nomor'] = this.nomor;
    data['perangkatLunak'] = this.perangkatLunak;
    data['versi'] = this.versi;
    data['tujuan'] = this.tujuan;
    data['metode'] = this.metode;
    data['namaUji'] = this.namaUji;
    data['kasusUji'] = this.kasusUji;
    data['hasilHarapan'] = this.hasilHarapan;
    data['hasilUji'] = this.hasilUji;
    data['keterangan'] = this.keterangan;
    data['jenis'] = this.jenis;
    data['divisi'] = this.divisi;
    return data;
  }
}
