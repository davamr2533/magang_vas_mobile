import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:retrofit/retrofit.dart';
import 'package:vas_reporting/base/base_paths.dart' as basePaths;
import 'package:vas_reporting/data/model/body/approval_body.dart';
import 'package:vas_reporting/data/model/body/form_ajuan_body.dart';
import 'package:vas_reporting/data/model/body/get_data_vas_body.dart';
import 'package:vas_reporting/data/model/response/form_response.dart';
import 'package:vas_reporting/data/model/response/get_data_response.dart';
import 'package:vas_reporting/data/model/response/get_data_uji_response.dart';
import 'package:vas_reporting/data/model/response/get_data_vas_response.dart';

part 'get_data_service.g.dart';


@RestApi()
abstract class GetDataService {
  factory GetDataService(Dio dio, {String baseUrl}) = _GetDataService;

  @GET(basePaths.urlGetAllData)
  Future<GetDataResponse> getAllData(
    @Header("Authorization") String token,
  );
  @POST(basePaths.urlApproval)
    Future<FormResponse> approval(
    @Header("Authorization") String token,
    @Body() ApprovalBody body);

  @POST(basePaths.urlGetVasForm)
    Future<GetDataVasResponse> getDataVas(
    @Header("Authorization") String token,
    @Body() GetDataVasBody? body);

  @GET(basePaths.urlGetUji)
    Future<GetDataUjiResponse> getDataUji(
    @Header("Authorization") String token
    );
}