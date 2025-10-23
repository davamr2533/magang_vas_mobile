import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/body/delete_drive_body.dart';
import '../repository/drive_repository.dart';

part 'delete_drive_state.dart';

class DeleteDriveCubit extends Cubit<DeleteDriveState> {
  DeleteDriveCubit() : super(DeleteDriveInitial());

  // Repository untuk berinteraksi dengan API Drive
  final DriveRepository repository = DriveRepository();

  /// Menghapus file atau folder dari drive.
  ///
  /// [token] digunakan untuk autentikasi pengguna.
  /// [body] berisi data file atau folder yang akan dihapus.
  ///
  /// State akan berubah dari:
  /// - DeleteDriveLoading saat proses dimulai
  /// - DeleteDriveSuccess jika berhasil
  /// - DeleteDriveFailure jika terjadi kesalahan
  Future<void> deleteDrive({
    required String token,
    required DeleteDriveBody body,
  }) async {
    try {
      // Emit state loading untuk menandakan proses sedang berlangsung
      emit(DeleteDriveLoading());

      // Panggil repository untuk menghapus data melalui API
      final result = await repository.deleteDrive(token: token, body: body);

      // Jika permintaan berhasil, kirim state sukses dengan pesan dan data hasil
      if (result.isSuccess) {
        emit(
          DeleteDriveSuccess(
            message: 'Item dihapus permanen dari drive.',
            data: result.dataResponse,
          ),
        );
      }
      // Jika permintaan gagal, kirim state gagal dengan pesan error dari response
      else {
        emit(DeleteDriveFailure(message: result.dataResponse.toString()));
      }
    } catch (e) {
      // Tangani error tak terduga seperti error jaringan atau parsing
      emit(DeleteDriveFailure(message: e.toString()));
    }
  }
}
