import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/body/add_to_trash_body.dart';
import '../repository/drive_repository.dart';

part 'add_to_trash_state.dart';

class AddToTrashCubit extends Cubit<AddToTrashState> {
  AddToTrashCubit() : super(AddToTrashInitial());

  // Repository untuk berinteraksi dengan API Drive
  final DriveRepository repository = DriveRepository();

  /// Memindahkan file atau folder ke trash.
  ///
  /// [token] digunakan untuk autentikasi.
  /// [body] berisi data file/folder yang akan dipindahkan.
  ///
  /// State akan berubah dari:
  /// - AddToTrashLoading saat proses dimulai
  /// - AddToTrashSuccess jika berhasil
  /// - AddToTrashFailure jika gagal
  Future<void> addToTrash({
    required String token,
    required AddToTrashBody body,
  }) async {
    try {
      // Emit state loading untuk menandakan proses sedang berjalan
      emit(AddToTrashLoading());

      // Panggil repository untuk mengirim permintaan ke API
      final result = await repository.addToTrash(token: token, body: body);

      // Jika permintaan berhasil, kirim state sukses dengan data hasil
      if (result.isSuccess) {
        emit(
          AddToTrashSuccess(
            message: 'Item berhasil dipindahkan ke Sampah.',
            data: result.dataResponse,
          ),
        );
      }
      // Jika permintaan gagal, kirim state gagal dengan pesan error dari response
      else {
        emit(AddToTrashFailure(message: result.dataResponse.toString()));
      }
    } catch (e) {
      // Tangani error tak terduga seperti error jaringan atau parsing
      emit(AddToTrashFailure(message: e.toString()));
    }
  }
}
