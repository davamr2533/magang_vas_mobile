import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vas_reporting/data/model/response/repository_response.dart';
import 'package:vas_reporting/screen/drive/data/model/body/add_folder_body.dart';
import 'package:vas_reporting/screen/drive/data/model/body/rename_body.dart';
import 'package:vas_reporting/screen/drive/data/model/body/starred_body.dart';
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
        response =
            RepositoriesResponse(isSuccess: false, statusCode: 503, dataResponse: e.toString());
      } else {
        response =
            RepositoriesResponse(isSuccess: false, statusCode: 500, dataResponse: e.toString());
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
            dataResponse: e.response?.data?['message']?.toString() ??
                'Please check your connection..');
        debugPrint('DioException (addFolder): ${e.response?.data?['message'] ?? e.message}');
      } else if (e is IOException) {
        response =
            RepositoriesResponse(isSuccess: false, statusCode: 503, dataResponse: e.toString());
      } else {
        response =
            RepositoriesResponse(isSuccess: false, statusCode: 500, dataResponse: e.toString());
      }
    }

    return response;
  }

  /// ✏️ Rename item pakai RenameBody (dipakai oleh RenameCubit)
  Future<RepositoriesResponse> renameItem(String token, RenameBody body) async {
    late RepositoriesResponse response;

    try {
      final value = await services.renameItem(token, body.toJson());

      response = RepositoriesResponse(
        isSuccess: true,
        statusCode: value.response?.statusCode ?? 200,
        dataResponse: value.data,
      );
    } catch (e) {
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse:
          e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (renameItem): ${e.response?.data?['message'] ?? e.message}');
      } else {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: 500,
          dataResponse: e.toString(),
        );
      }
    }

    return response;
  }

  /// 🆕 Rename folder/file (alternatif mengambil param langsung)
  Future<RepositoriesResponse> renameDrive({
    required String token,
    required int itemId,
    required String newName,
  }) async {
    late RepositoriesResponse response;

    try {
      final value = await services.renameItem(token, {
        'id': itemId,
        'new_name': newName,
      });

      response = RepositoriesResponse(
        isSuccess: true,
        statusCode: value.response?.statusCode ?? 200,
        dataResponse: value.data,
      );
    } catch (e) {
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse:
          e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (renameDrive): ${e.response?.data?['message'] ?? e.message}');
      } else {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: 500,
          dataResponse: e.toString(),
        );
      }
    }

    return response;
  }

  /// 🆕 Tambah ke berbintang
  Future<RepositoriesResponse> starDrive({
    required String token,
    required StarredBody body,
  }) async {
    late RepositoriesResponse response;

    try {
      final value = await services.starItem(token, body);

      response = RepositoriesResponse(
        isSuccess: true,
        statusCode: value.response?.statusCode ?? 200,
        dataResponse: value.data,
      );
    } catch (e) {
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse:
          e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (starDrive): ${e.response?.data?['message'] ?? e.message}');
      } else {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: 500,
          dataResponse: e.toString(),
        );
      }
    }

    return response;
  }

  /// 🆕 Hapus dari berbintang
  Future<RepositoriesResponse> unstarDrive({
    required String token,
    required int itemId,
  }) async {
    late RepositoriesResponse response;

    try {
      final value = await services.unstarItem(token, {
        'id': itemId,
      });

      response = RepositoriesResponse(
        isSuccess: true,
        statusCode: value.response?.statusCode ?? 200,
        dataResponse: value.data,
      );
    } catch (e) {
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse:
          e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (unstarDrive): ${e.response?.data?['message'] ?? e.message}');
      } else {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: 500,
          dataResponse: e.toString(),
        );
      }
    }

    return response;
  }

  /// 🔁 Toggle starred item (pakai pola StarredBody)
  Future<RepositoriesResponse> toggleStar(String token, StarredBody body) async {
    // body diharapkan Map atau model yang punya toJson()
    late RepositoriesResponse response;

    try {
      // Jika body adalah Map (contoh dari toJson()), gunakan langsung
      final dynamic payload;
      if (body is Map) {
        payload = body;
      } else if (body is StarredBody) {
        payload = body.toJson();
      } else {
        throw Exception('Invalid body type for toggleStar: ${body.runtimeType}');
      }

      // backend biasanya punya endpoint terpisah untuk star/unstar.
      // Kita gunakan services.starItem / services.unstarItem bergantung pada payload['is_starred']
      // final bool? isStarred = payload['is_starred'] as bool?;
      final int? id = payload['id'] as int?;

      if (id == null) {
        throw Exception('id is required for toggleStar');
      }

      if (payload['is_starred'] == 'FALSE') {
        // kalau sekarang sudah starred -> panggil unstar
        final value = await services.unstarItem(token, {'id': id});
        response = RepositoriesResponse(
          isSuccess: true,
          statusCode: value.response?.statusCode ?? 200,
          dataResponse: value.data,
        );
      } else {
        // kalau belum starred -> panggil star
        final value = await services.starItem(token, body);
        response = RepositoriesResponse(
          isSuccess: true,
          statusCode: value.response.statusCode ?? 200,
          dataResponse: value.data,
        );
      }
    } catch (e) {
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse: e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (toggleStar): ${e.response?.data?['message'] ?? e.message}');
      } else {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: 500,
          dataResponse: e.toString(),
        );
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
  // Menambahkan folder baru ke drive
  // ================================================================
  Future<RepositoriesResponse> deleteDrive({
    required String token,
    required DeleteDriveBody body
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
      if (e is DioException) {
        response = RepositoriesResponse(
            isSuccess: false,
            statusCode: e.response?.statusCode ?? 0,
            dataResponse: e.response?.data?['message']?.toString() ??
                'Please check your connection..');
        debugPrint('DioException (addFolder): ${e.response?.data?['message'] ?? e.message}');
      } else if (e is IOException) {
        response =
            RepositoriesResponse(isSuccess: false, statusCode: 503, dataResponse: e.toString());
      } else {
        response =
            RepositoriesResponse(isSuccess: false, statusCode: 500, dataResponse: e.toString());
      }
    }

    return response;
  }

  /// ✏️ Rename item pakai RenameBody (dipakai oleh RenameCubit)
  Future<RepositoriesResponse> renameItem(String token, RenameBody body) async {
    late RepositoriesResponse response;

    try {
      final value = await services.renameItem(token, body.toJson());

      response = RepositoriesResponse(
        isSuccess: true,
        statusCode: value.response?.statusCode ?? 200,
        dataResponse: value.data,
      );
    } catch (e) {
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse:
          e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (renameItem): ${e.response?.data?['message'] ?? e.message}');
      } else {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: 500,
          dataResponse: e.toString(),
        );
      }
    }

    return response;
  }

  /// 🆕 Rename folder/file (alternatif mengambil param langsung)
  Future<RepositoriesResponse> renameDrive({
    required String token,
    required int itemId,
    required String newName,
  }) async {
    late RepositoriesResponse response;

    try {
      final value = await services.renameItem(token, {
        'id': itemId,
        'new_name': newName,
      });

      response = RepositoriesResponse(
        isSuccess: true,
        statusCode: value.response?.statusCode ?? 200,
        dataResponse: value.data,
      );
    } catch (e) {
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse:
          e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (renameDrive): ${e.response?.data?['message'] ?? e.message}');
      } else {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: 500,
          dataResponse: e.toString(),
        );
      }
    }

    return response;
  }

  /// 🆕 Tambah ke berbintang
  Future<RepositoriesResponse> starDrive({
    required String token,
    required StarredBody body,
  }) async {
    late RepositoriesResponse response;

    try {
      final value = await services.starItem(token, body);

      response = RepositoriesResponse(
        isSuccess: true,
        statusCode: value.response?.statusCode ?? 200,
        dataResponse: value.data,
      );
    } catch (e) {
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse:
          e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (starDrive): ${e.response?.data?['message'] ?? e.message}');
      } else {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: 500,
          dataResponse: e.toString(),
        );
      }
    }

    return response;
  }

  /// 🆕 Hapus dari berbintang
  Future<RepositoriesResponse> unstarDrive({
    required String token,
    required int itemId,
  }) async {
    late RepositoriesResponse response;

    try {
      final value = await services.unstarItem(token, {
        'id': itemId,
      });

      response = RepositoriesResponse(
        isSuccess: true,
        statusCode: value.response?.statusCode ?? 200,
        dataResponse: value.data,
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
        debugPrint('DioException (unstarDrive): ${e.response?.data?['message'] ?? e.message}');
      } else {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: 500,
          dataResponse: e.toString(),
        );
      }
    }

    return response;
  }

  /// 🔁 Toggle starred item (pakai pola StarredBody)
  Future<RepositoriesResponse> toggleStar(String token, StarredBody body) async {
    // body diharapkan Map atau model yang punya toJson()
    late RepositoriesResponse response;

    try {
      // Jika body adalah Map (contoh dari toJson()), gunakan langsung
      final dynamic payload;
      if (body is Map) {
        payload = body;
      } else if (body is StarredBody) {
        payload = body.toJson();
      } else {
        throw Exception('Invalid body type for toggleStar: ${body.runtimeType}');
      }

      // backend biasanya punya endpoint terpisah untuk star/unstar.
      // Kita gunakan services.starItem / services.unstarItem bergantung pada payload['is_starred']
      // final bool? isStarred = payload['is_starred'] as bool?;
      final int? id = payload['id'] as int?;

      if (id == null) {
        throw Exception('id is required for toggleStar');
      }

      if (payload['is_starred'] == 'FALSE') {
        // kalau sekarang sudah starred -> panggil unstar
        final value = await services.unstarItem(token, {'id': id});
        response = RepositoriesResponse(
          isSuccess: true,
          statusCode: value.response?.statusCode ?? 200,
          dataResponse: value.data,
        );
      } else {
        // kalau belum starred -> panggil star
        final value = await services.starItem(token, body);
        response = RepositoriesResponse(
          isSuccess: true,
          statusCode: value.response.statusCode ?? 200,
          dataResponse: value.data,
        );
      }
    } catch (e) {
      if (e is DioException) {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse: e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException (toggleStar): ${e.response?.data?['message'] ?? e.message}');
      } else {
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: 500,
          dataResponse: e.toString(),
        );
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
