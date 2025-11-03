import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:retrofit/retrofit.dart';
import 'package:vas_reporting/base/base_paths.dart' as basePaths;
import 'package:vas_reporting/data/model/body/approval_body.dart';
import 'package:vas_reporting/data/model/body/form_ajuan_body.dart';
import 'package:vas_reporting/data/model/body/form_uji_body.dart';
import 'package:vas_reporting/data/model/body/form_vas_body.dart';
import 'package:vas_reporting/data/model/response/form_response.dart';

part 'form_service.g.dart';


@RestApi()
abstract class FormService {
  factory FormService(Dio dio, {String baseUrl}) = _FormService;

  @POST(basePaths.urlFormAjuan)
  Future<FormResponse> formAjuan(
    @Header("Authorization") String token,
    @Body() FormAjuanBody body);

  @POST(basePaths.urlFormVas)
  Future<FormResponse> formVas(
    @Header("Authorization") String token,
    @Body() FormVasBody body);

  @POST(basePaths.urlFormUji)
  Future<FormResponse> formUji(
    @Header("Authorization") String token,
    @Body() FormUjiBody body);
}