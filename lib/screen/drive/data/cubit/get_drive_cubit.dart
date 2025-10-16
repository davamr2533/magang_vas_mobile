import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/response/get_data_drive_response.dart';
import '../repository/drive_repository.dart';

part 'get_drive_state.dart';

class DriveCubit extends Cubit<DriveState> {
  DriveCubit() : super(DriveInitial());

  // Menginisialisasi repository
  final DriveRepository repository = DriveRepository();

  /// Method untuk mengambil data drive dari repository.
  Future<void> getDriveData({required String token}) async {
    try {
      // 1. Emit state loading untuk menampilkan progress indicator di UI
      emit(DriveLoading());

      // 2. Panggil method dari repository
      final value = await repository.getDriveData(token);

      // 3. Cek apakah response dari repository sukses dan tipe datanya sesuai
      if (value.isSuccess && value.dataResponse is GetDataDriveResponse) {
        // Jika sukses, cast dataResponse ke tipe yang benar
        final result = value.dataResponse as GetDataDriveResponse;
        // Emit state success bersama dengan datanya
        emit(DriveDataSuccess(result));
      } else {
        // Jika gagal, emit state failure bersama pesan error dari repository
        emit(DriveDataFailure(message: value.dataResponse.toString()));
      }
    } catch (error) {
      // 4. Tangani error tak terduga (misalnya dari dalam Cubit itu sendiri)
      emit(DriveDataFailure(message: error.toString()));
    }
  }
}