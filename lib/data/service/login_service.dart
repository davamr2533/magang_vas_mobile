import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:retrofit/retrofit.dart';
import 'package:vas_reporting/base/base_paths.dart' as basePaths;
import 'package:vas_reporting/data/model/body/login_body.dart';
import 'package:vas_reporting/data/model/response/login_response.dart';

part 'login_service.g.dart';

@RestApi()
abstract class LoginService {
  factory LoginService(Dio dio, {String baseUrl}) = _LoginService;

  @POST(basePaths.urlLogin)
  Future<LoginResponse> login(
    @Body() LoginBody body);
}