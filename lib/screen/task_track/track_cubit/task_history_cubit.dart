import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vas_reporting/screen/task_track/task_track_service.dart';
import 'package:vas_reporting/screen/task_track/task_track_response.dart';

part 'task_history_state.dart';

class TaskHistoryCubit extends Cubit<TaskHistoryState> {
  final TaskTrackService service;

  TaskHistoryCubit(this.service) : super(TaskHistoryInitial());

  Future<void> fetchHistory() async {
    emit(TaskHistoryLoading());
    try {
      final result = await service.getTaskHistory();

      if (result != null && result['status'] == "success") {
        final data = (result['data'] as List)
            .map((e) => TaskHistoryResponse.fromJson(e))
            .toList();

        emit(TaskHistorySuccess(data));
      } else {
        emit(TaskHistoryFailure("Data history tidak ditemukan"));
      }
    } catch (e) {
      emit(TaskHistoryFailure(e.toString()));
    }
  }
}
