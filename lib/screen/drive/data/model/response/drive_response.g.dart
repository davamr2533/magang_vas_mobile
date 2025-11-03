// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriveResponse _$DriveResponseFromJson(Map<String, dynamic> json) =>
    DriveResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$DriveResponseToJson(DriveResponse instance) =>
    <String, dynamic>{'status': instance.status, 'message': instance.message};
