import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/drive_repository.dart';

part 'upload_file_state.dart';

class UploadFileCubit extends Cubit<UploadFileState> {
  UploadFileCubit() : super(UploadFileInitial());

  final DriveRepository repository = DriveRepository();

  Future<void> uploadFile({
    required String token,
    required String filePath,
    required String fileName,
    required String userId,
    required int id,
    Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      emit(UploadFileLoading());

      final result = await repository.uploadFile(
        token: token,
        filePath: filePath,
        fileName: fileName,
        userId: userId,
        id: id,
        onSendProgress: onSendProgress,
      );

      if (result.isSuccess) {
        emit(
          UploadFileSuccess(
            message: 'File berhasil diunggah.',
            data: result.dataResponse,
          ),
        );
      } else {
        emit(UploadFileFailure(message: result.dataResponse.toString()));
      }
    } catch (e) {
      emit(UploadFileFailure(message: e.toString()));
    }
  }
}