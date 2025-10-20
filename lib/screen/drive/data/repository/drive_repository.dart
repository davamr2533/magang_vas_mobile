import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vas_reporting/data/model/response/repository_response.dart';
import 'package:vas_reporting/screen/drive/data/model/body/add_folder_body.dart';
import 'package:vas_reporting/screen/drive/data/model/body/add_to_trash_body.dart';
import 'package:vas_reporting/screen/drive/data/model/body/delete_drive_body.dart';
import 'package:vas_reporting/screen/drive/data/model/body/recovery_drive_body.dart';
import '../service/drive_service.dart';

class DriveRepository {
  // ================================================================
  // Inisialisasi service dari GetIt untuk mengakses API Drive
  // ================================================================
  final services = GetIt.I.get<DriveService>();

  // ================================================================
  // Mengambil semua data drive
  // ================================================================
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
      // =========== Error handling ===========
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

  // ================================================================
  // Menambahkan folder baru ke drive
  // ================================================================
  Future<RepositoriesResponse> addFolder({
    required String token,
    required AddFolderBody body,
  }) async {
    late RepositoriesResponse response;

    try {
      // =========== Panggil service ===========
      await services.addFolder(token, body).then((value) {
        response = RepositoriesResponse(
          isSuccess: true,
          statusCode: value.status,
          dataResponse: value,
        );
      });
    } catch (e) {
      // =========== Error handling ===========
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

  // ================================================================
  // Upload file ke drive
  // ================================================================
  Future<RepositoriesResponse> uploadFile({
    required String token,
    required String filePath,
    required String fileName,
    required String userId,
    required int id,
  }) async {
    late RepositoriesResponse response;

    try {
      // =========== Siapkan Multipart File ===========
      final file = await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      );

      // =========== Panggil service upload ===========
      final result = await services.uploadFile(
        "Bearer $token",
        file,
        id,
        userId,
      );

      response = RepositoriesResponse(
        isSuccess: true,
        statusCode: result.status,
        dataResponse: result,
      );
    } catch (e) {
      // =========== Error handling ===========
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse:
          e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (uploadFile): ${e.response?.data?['message'] ?? e.message}');
      } else if (e is IOException) {
        response = RepositoriesResponse(isSuccess: false, statusCode: 503, dataResponse: e.toString());
      } else {
        response = RepositoriesResponse(isSuccess: false, statusCode: 500, dataResponse: e.toString());
      }
    }

    return response;
  }

  // ================================================================
  // Memindahkan file atau folder ke trash
  // ================================================================
  Future<RepositoriesResponse> addToTrash({
    required String token,
    required AddToTrashBody body,
  }) async {
    late RepositoriesResponse response;

    try {
      // =========== Panggil service ===========
      await services.addToTrash(token, body).then((value) {
        response = RepositoriesResponse(
          isSuccess: true,
          statusCode: value.status,
          dataResponse: value,
        );
      });
    } catch (e) {
      // =========== Error handling ===========
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse:
          e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (addToTrash): ${e.response?.data?['message'] ?? e.message}');
      } else if (e is IOException) {
        response = RepositoriesResponse(isSuccess: false, statusCode: 503, dataResponse: e.toString());
      } else {
        response = RepositoriesResponse(isSuccess: false, statusCode: 500, dataResponse: e.toString());
      }
    }

    return response;
  }

  // ================================================================
  // Mengembalikan file atau folder dari trash
  // ================================================================
  Future<RepositoriesResponse> recoveryDrive({
    required String token,
    required RecoveryDriveBody body,
  }) async {
    late RepositoriesResponse response;

    try {
      // =========== Panggil service ===========
      await services.recoveryDrive(token, body).then((value) {
        response = RepositoriesResponse(
          isSuccess: true,
          statusCode: value.status,
          dataResponse: value,
        );
      });
    } catch (e) {
      // =========== Error handling ===========
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse:
          e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (recoveryDrive): ${e.response?.data?['message'] ?? e.message}');
      } else if (e is IOException) {
        response = RepositoriesResponse(isSuccess: false, statusCode: 503, dataResponse: e.toString());
      } else {
        response = RepositoriesResponse(isSuccess: false, statusCode: 500, dataResponse: e.toString());
      }
    }

    return response;
  }

  // ================================================================
  // Menghapus file atau folder dari drive secara permanen
  // ================================================================
  Future<RepositoriesResponse> deleteDrive({
    required String token,
    required DeleteDriveBody body,
  }) async {
    late RepositoriesResponse response;

    try {
      // =========== Panggil service ===========
      await services.deleteDrive(token, body).then((value) {
        response = RepositoriesResponse(
          isSuccess: true,
          statusCode: value.status,
          dataResponse: value,
        );
      });
    } catch (e) {
      // =========== Error handling ===========
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse:
          e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (deleteDrive): ${e.response?.data?['message'] ?? e.message}');
      } else if (e is IOException) {
        response = RepositoriesResponse(isSuccess: false, statusCode: 503, dataResponse: e.toString());
      } else {
        response = RepositoriesResponse(isSuccess: false, statusCode: 500, dataResponse: e.toString());
      }
    }

    return response;
  }
}
