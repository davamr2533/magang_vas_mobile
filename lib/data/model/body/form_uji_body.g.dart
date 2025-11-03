// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_uji_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormUjiBody _$FormUjiBodyFromJson(Map<String, dynamic> json) => FormUjiBody(
  status: json['status'] as String?,
  nomor: json['nomor'] as String?,
  perangkatLunak: json['perangkat_lunak'] as String?,
  versi: json['versi'] as String?,
  tujuan: json['tujuan'] as String?,
  metode: json['metode'] as String?,
  namaUji: json['nama_uji'] as String?,
  kasusUji: json['kasus_uji'] as String?,
  hasilHarapan: json['hasil_harapan'] as String?,
  hasilUji: json['hasil_uji'] as String?,
  keterangan: json['keterangan'] as String?,
);

Map<String, dynamic> _$FormUjiBodyToJson(FormUjiBody instance) =>
    <String, dynamic>{
      'status': instance.status,
      'nomor': instance.nomor,
      'perangkat_lunak': instance.perangkatLunak,
      'versi': instance.versi,
      'tujuan': instance.tujuan,
      'metode': instance.metode,
      'nama_uji': instance.namaUji,
      'kasus_uji': instance.kasusUji,
      'hasil_harapan': instance.hasilHarapan,
      'hasil_uji': instance.hasilUji,
      'keterangan': instance.keterangan,
    };
