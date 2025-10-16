import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vas_reporting/data/model/response/repository_response.dart';
import 'package:vas_reporting/screen/drive/data/model/body/add_folder_body.dart';
import '../service/drive_service.dart';

class DriveRepository {
  // Instance DriveService dari GetIt
  final services = GetIt.I.get<DriveService>();

  /// Mengambil semua data drive
  Future<RepositoriesResponse> getDriveData(String token) async {
    late RepositoriesResponse response;

    try {
      await services.getAllDrive(token).then((value) {
        response = RepositoriesResponse(
          isSuccess: true,
          statusCode: value.status,
          dataResponse: value,
        );
      });
    } catch (e) {
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse:
          e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException: ${e.response?.data?['message'] ?? e.message}');
      } else if (e is IOException) {
        response = RepositoriesResponse(isSuccess: false, statusCode: 503, dataResponse: e.toString());
      } else {
        response = RepositoriesResponse(isSuccess: false, statusCode: 500, dataResponse: e.toString());
      }
    }

    return response;
  }

  /// 🆕 Menambah folder baru di drive
  Future<RepositoriesResponse> addFolder({
    required String token,
    required AddFolderBody body
  }) async {
    late RepositoriesResponse response;

    try {
      // Panggil DriveService untuk tambah folder
      await services.addFolder(token, body).then((value) {
        response = RepositoriesResponse(
          isSuccess: true,
          statusCode: value.status,
          dataResponse: value,
        );
      });
    } catch (e) {
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse:
          e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (addFolder): ${e.response?.data?['message'] ?? e.message}');
      } else if (e is IOException) {
        response = RepositoriesResponse(isSuccess: false, statusCode: 503, dataResponse: e.toString());
      } else {
        response = RepositoriesResponse(isSuccess: false, statusCode: 500, dataResponse: e.toString());
      }
    }

    return response;
  }
}
