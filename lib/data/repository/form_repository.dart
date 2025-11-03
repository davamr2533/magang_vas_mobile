
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vas_reporting/data/model/body/approval_body.dart';
import 'package:vas_reporting/data/model/body/form_ajuan_body.dart';
import 'package:vas_reporting/data/model/body/form_uji_body.dart';
import 'package:vas_reporting/data/model/body/form_vas_body.dart';
import 'package:vas_reporting/data/model/response/repository_response.dart';
import 'package:vas_reporting/data/service/form_service.dart';

class FormRepositories {
  final services = GetIt.I.get<FormService>();
  late RepositoriesResponse response;

  Future<RepositoriesResponse>form(String token, FormAjuanBody body) async {
    final services = GetIt.I.get<FormService>();

    late RepositoriesResponse response;

    try {
      await services.formAjuan(token, body).then((value) {
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

  Future<RepositoriesResponse>formVas(String token, FormVasBody body) async {
    final services = GetIt.I.get<FormService>();

    late RepositoriesResponse response;

    try {
      await services.formVas(token, body).then((value) {
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

  Future<RepositoriesResponse>formUji(String token, FormUjiBody body) async {
    final services = GetIt.I.get<FormService>();

    late RepositoriesResponse response;

    try {
      await services.formUji(token, body).then((value) {
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
