import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vas_reporting/screen/UjicobaApiBaru/uji_service.dart';
import 'package:vas_reporting/screen/UjicobaApiBaru/uji_response.dart';

part 'uji_state.dart';

class UjiCubit extends Cubit<UjiState> {
  final UjiService service;

  UjiCubit(this.service) : super(UjiInitial());

  Future<void> fetchUji() async {
    emit(UjiLoading());
    try {
      final result = await service.getUji();

      if (result != null && result['status'] == "success") {
        final data = (result['data'] as List)
            .map((e) => UjiResponse.fromJson(e))
            .toList();

        emit(UjiSuccess(data));
      } else {
        emit(UjiFailure("Data tidak ditemukan"));
      }
    } catch (e) {
      emit(UjiFailure(e.toString()));
    }
  }
}
