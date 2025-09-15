// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_data_uji_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDataUjiResponse _$GetDataUjiResponseFromJson(Map<String, dynamic> json) =>
    GetDataUjiResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetDataUjiResponseToJson(GetDataUjiResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
