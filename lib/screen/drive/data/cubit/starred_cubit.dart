import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_reporting/screen/drive/data/model/body/starred_body.dart';
import 'package:vas_reporting/screen/drive/data/repository/drive_repository.dart';

part 'starred_state.dart';

class StarredCubit extends Cubit<StarredState> {
  StarredCubit() : super(StarredInitial());
  // Inisialisasi repository
  final DriveRepository repository = DriveRepository();

  Future<void> toggleStar({
    required String token,
    required StarredBody body,
  }) async {
    emit(StarredLoading());
    final result = await repository.toggleStar(token, body);

    if (result.isSuccess) {
      final message = body.isStarred=='TRUE'
          ? 'Item berhasil ditambahkan ke berbintang'
          : 'Item berhasil dihapus dari berbintang';

      emit(
        StarredSuccess(
          message: message,
          data: result.dataResponse,
        ),
      );
    } else {
      emit(StarredFailure(result.dataResponse.toString()));
    }
  }

}
