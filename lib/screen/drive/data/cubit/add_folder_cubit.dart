import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_reporting/screen/drive/data/model/body/add_folder_body.dart';
import '../model/response/drive_response.dart';
import '../repository/drive_repository.dart';

part 'add_folder_state.dart';

class AddFolderCubit extends Cubit<AddFolderState> {
  AddFolderCubit() : super(AddFolderInitial());

  // Inisialisasi repository
  final DriveRepository repository = DriveRepository();

  /// Method untuk menambah folder baru di drive
  Future<void> addFolder({
    required String token,
    required AddFolderBody body,
  }) async {
    try {
      emit(AddFolderLoading());

      final result = await repository.addFolder(token: token, body: body);

      // 3️⃣ Cek hasil dari repository
      if (result.isSuccess) {
        emit(
          AddFolderSuccess(
            message: 'Folder berhasil ditambahkan!',
            data: result.dataResponse,
          ),
        );
      } else {
        emit(AddFolderFailure(message: result.dataResponse.toString()));
      }
    } catch (e) {
      // 4️⃣ Tangani error tak terduga
      emit(AddFolderFailure(message: e.toString()));
    }
  }
}
