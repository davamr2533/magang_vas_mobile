import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/body/rename_drive_body.dart';
import '../repository/drive_repository.dart';

part 'rename_drive_state.dart';

class RenameDriveCubit extends Cubit<RenameDriveState> {
  RenameDriveCubit() : super(RenameDriveInitial());

  // Repository untuk berinteraksi dengan API Drive
  final DriveRepository repository = DriveRepository();

  Future<void> renameDrive({
    required String token,
    required RenameDriveBody body,
  }) async {
    try {
      // Emit state loading untuk menandakan proses sedang berlangsung
      emit(RenameDriveLoading());

      // Panggil repository untuk mengembalikan item dari trash melalui API
      final result = await repository.renameDrive(token: token, body: body);

      // Jika permintaan berhasil, kirim state sukses dengan pesan dan data hasil
      if (result.isSuccess) {
        emit(
          RenameDriveSuccess(
            message: 'Berhasil mengubah nama item',
            data: result.dataResponse,
          ),
        );
      }
      // Jika permintaan gagal, kirim state gagal dengan pesan error dari response
      else {
        emit(RenameDriveFailure(message: result.dataResponse.toString()));
      }
    } catch (e) {
      // Tangani error tak terduga seperti error jaringan atau parsing
      emit(RenameDriveFailure(message: e.toString()));
    }
  }
}
