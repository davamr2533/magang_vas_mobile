
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vas_reporting/data/model/body/approval_body.dart';
import 'package:vas_reporting/data/model/body/get_data_vas_body.dart';
import 'package:vas_reporting/data/model/response/repository_response.dart';
import 'package:vas_reporting/data/service/get_data_service.dart';
class GetDataRepositories {
  final services = GetIt.I.get<GetDataService>();

  late RepositoriesResponse response;
  Future<RepositoriesResponse>getAllDataa(String token) async {
    final services = GetIt.I.get<GetDataService>();

    late RepositoriesResponse response;

    try {
      await services.getAllData(token).then((value) {
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
  Future<RepositoriesResponse>approval(String token, ApprovalBody body) async {
    final services = GetIt.I.get<GetDataService>();

    late RepositoriesResponse response;

    try {
      await services.approval(token, body).then((value) {
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
  Future<RepositoriesResponse>getDataVas(String token, GetDataVasBody? body) async {
    final services = GetIt.I.get<GetDataService>();

    late RepositoriesResponse response;

    try {
      await services.getDataVas(token, body).then((value) {
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
  Future<RepositoriesResponse>getDataUji(String token) async {
    final services = GetIt.I.get<GetDataService>();

    late RepositoriesResponse response;

    try {
      await services.getDataUji(token).then((value) {
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
