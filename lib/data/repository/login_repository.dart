
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vas_reporting/data/model/body/login_body.dart';
import 'package:vas_reporting/data/model/response/repository_response.dart';
import 'package:vas_reporting/data/service/login_service.dart';
class LoginRepositories {
  final services = GetIt.I.get<LoginService>();

  late RepositoriesResponse response;
  Future<RepositoriesResponse> login(LoginBody body) async {
    final services = GetIt.I.get<LoginService>();

    late RepositoriesResponse response;

    try {
      await services.login(body).then((value) {
        response = RepositoriesResponse(isSuccess: true, statusCode: value.status, dataResponse: value);
      });
    } catch (e) {
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse: e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint(e.response?.data?['message'] ?? 'Failed');
      } else if (e is IOException) {
        response = RepositoriesResponse(isSuccess: false, statusCode: 500, dataResponse: e.toString());
      } else {
        response = RepositoriesResponse(isSuccess: false, statusCode: 0, dataResponse: e.toString());
      }
    }
    return response;

  }
}
