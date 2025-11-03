// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_ajuan_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormAjuanBody _$FormAjuanBodyFromJson(Map<String, dynamic> json) =>
    FormAjuanBody(
      nama: json['nama'] as String?,
      divisi: json['divisi'] as String?,
      sistem: json['sistem'] as String?,
      jenis: json['jenis'] as String?,
      anggaran: json['anggaran'] as String?,
      masalah: json['masalah'] as String?,
      output: json['output'] as String?,
    );

Map<String, dynamic> _$FormAjuanBodyToJson(FormAjuanBody instance) =>
    <String, dynamic>{
      'nama': instance.nama,
      'divisi': instance.divisi,
      'sistem': instance.sistem,
      'jenis': instance.jenis,
      'anggaran': instance.anggaran,
      'masalah': instance.masalah,
      'output': instance.output,
    };
