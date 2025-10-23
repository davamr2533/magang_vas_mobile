import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/body/recovery_drive_body.dart';
import '../repository/drive_repository.dart';

part 'recovery_drive_state.dart';

class RecoveryDriveCubit extends Cubit<RecoveryDriveState> {
  RecoveryDriveCubit() : super(RecoveryDriveInitial());

  // Repository untuk berinteraksi dengan API Drive
  final DriveRepository repository = DriveRepository();

  /// Mengembalikan file atau folder dari trash ke lokasi semula.
  ///
  /// [token] digunakan untuk autentikasi pengguna.
  /// [body] berisi data file atau folder yang akan dikembalikan.
  ///
  /// State akan berubah dari:
  /// - RecoveryDriveLoading saat proses dimulai
  /// - RecoveryDriveSuccess jika berhasil
  /// - RecoveryDriveFailure jika terjadi kesalahan
  Future<void> recoveryDrive({
    required String token,
    required RecoveryDriveBody body,
  }) async {
    try {
      // Emit state loading untuk menandakan proses sedang berlangsung
      emit(RecoveryDriveLoading());

      // Panggil repository untuk mengembalikan item dari trash melalui API
      final result = await repository.recoveryDrive(token: token, body: body);

      // Jika permintaan berhasil, kirim state sukses dengan pesan dan data hasil
      if (result.isSuccess) {
        emit(
          RecoveryDriveSuccess(
            message: 'Item berhasil dikembalikan dari Sampah.',
            data: result.dataResponse,
          ),
        );
      }
      // Jika permintaan gagal, kirim state gagal dengan pesan error dari response
      else {
        emit(RecoveryDriveFailure(message: result.dataResponse.toString()));
      }
    } catch (e) {
      // Tangani error tak terduga seperti error jaringan atau parsing
      emit(RecoveryDriveFailure(message: e.toString()));
    }
  }
}
