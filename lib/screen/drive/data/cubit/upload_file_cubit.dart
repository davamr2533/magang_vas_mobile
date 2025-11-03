import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/drive_repository.dart';

part 'upload_file_state.dart';

class UploadFileCubit extends Cubit<UploadFileState> {
  UploadFileCubit() : super(UploadFileInitial());

  // Repository untuk mengakses API Drive
  final DriveRepository repository = DriveRepository();

  /// Mengunggah file ke drive.
  ///
  /// [token] digunakan untuk autentikasi pengguna.
  /// [filePath] adalah path lokal file yang akan diunggah.
  /// [fileName] nama file yang akan ditampilkan di drive.
  /// [userId] ID pengguna yang melakukan unggahan.
  /// [id] ID folder atau lokasi tujuan penyimpanan.
  ///
  /// State akan berubah dari:
  /// - UploadFileLoading saat proses dimulai
  /// - UploadFileSuccess jika unggahan berhasil
  /// - UploadFileFailure jika unggahan gagal
  Future<void> uploadFile({
    required String token,
    required String filePath,
    required String fileName,
    required String userId,
    required int id,
  }) async {
    try {
      // Emit state loading untuk menandakan proses sedang berjalan
      emit(UploadFileLoading());

      // Panggil repository untuk melakukan proses upload melalui API
      final result = await repository.uploadFile(
        token: token,
        filePath: filePath,
        fileName: fileName,
        userId: userId,
        id: id,
      );

      // Jika proses berhasil, kirim state sukses dengan data hasil
      if (result.isSuccess) {
        emit(
          UploadFileSuccess(
            message: 'File berhasil diunggah.',
            data: result.dataResponse,
          ),
        );
      }
      // Jika gagal, kirim state gagal dengan pesan error dari response
      else {
        emit(UploadFileFailure(message: result.dataResponse.toString()));
      }
    } catch (e) {
      // Tangani error tak terduga seperti error jaringan atau response tidak valid
      emit(UploadFileFailure(message: e.toString()));
    }
  }
}
