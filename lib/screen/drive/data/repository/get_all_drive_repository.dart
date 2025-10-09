import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vas_reporting/data/model/response/repository_response.dart';
import '../service/drive_service.dart';


class DriveRepository {
  // Mengambil instance DriveService dari GetIt
  final services = GetIt.I.get<DriveService>();

  /// Method untuk mengambil data drive dari service.
  Future<RepositoriesResponse> getDriveData(String token) async {
    // Mendeklarasikan variabel response yang akan diisi di dalam blok try-catch
    late RepositoriesResponse response;

    try {
      // Memanggil method getDriveData dari service
      await services.getAllDrive(token).then((value) {
        // Jika berhasil, bungkus hasilnya ke dalam RepositoriesResponse
        response = RepositoriesResponse(
          isSuccess: true,
          statusCode: value.status, // Mengambil status "success" dari body response
          dataResponse: value,      // 'value' adalah objek GetDataDriveResponse lengkap
        );
      });
    } catch (e) {
      // Jika terjadi error, tangani berdasarkan tipenya
      if (e is DioException) {
        // Error yang berasal dari Dio (masalah jaringan, status code 4xx/5xx)
        response = RepositoriesResponse(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 0,
          dataResponse: e.response?.data?['message']?.toString() ?? 'Please check your connection..',
        );
        debugPrint('DioException: ${e.response?.data?['message'] ?? e.message}');
      } else if (e is IOException) {
        // Error I/O, misalnya tidak ada koneksi internet sama sekali
        response = RepositoriesResponse(isSuccess: false, statusCode: 503, dataResponse: e.toString());
      } else {
        // Error lainnya yang tidak terduga
        response = RepositoriesResponse(isSuccess: false, statusCode: 500, dataResponse: e.toString());
      }
    }

    // Kembalikan response yang sudah terbungkus rapi
    return response;
  }
}