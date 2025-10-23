// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_vas_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormVasBody _$FormVasBodyFromJson(Map<String, dynamic> json) => FormVasBody(
  status: json['status'] as String?,
  nomor: json['nomor'] as String?,
  pengerjaan: json['pengerjaan'] as String?,
  diterimaOleh: json['diterima_oleh'] as String?,
  disetujuiOleh: json['disetujui_oleh'] as String?,
  catatan: json['catatan'] as String?,
  wawancara: json['wawancara'] as String?,
  konfirmasiDesain: json['konfirmasi_desain'] as String?,
  perancanganDatabase: json['perancangan_database'] as String?,
  pengembanganSoftware: json['pengembangan_software'] as String?,
  debugging: json['debugging'] as String?,
  testing: json['testing'] as String?,
  trial: json['trial'] as String?,
  production: json['production'] as String?,
);

Map<String, dynamic> _$FormVasBodyToJson(FormVasBody instance) =>
    <String, dynamic>{
      'status': instance.status,
      'nomor': instance.nomor,
      'pengerjaan': instance.pengerjaan,
      'diterima_oleh': instance.diterimaOleh,
      'disetujui_oleh': instance.disetujuiOleh,
      'catatan': instance.catatan,
      'wawancara': instance.wawancara,
      'konfirmasi_desain': instance.konfirmasiDesain,
      'perancangan_database': instance.perancanganDatabase,
      'pengembangan_software': instance.pengembanganSoftware,
      'debugging': instance.debugging,
      'testing': instance.testing,
      'trial': instance.trial,
      'production': instance.production,
    };
