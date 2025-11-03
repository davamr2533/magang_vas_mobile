// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_data_vas_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDataVasResponse _$GetDataVasResponseFromJson(Map<String, dynamic> json) =>
    GetDataVasResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetDataVasResponseToJson(GetDataVasResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
