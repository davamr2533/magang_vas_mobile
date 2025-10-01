import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vas_reporting/screen/task_track/task_track_response.dart';
import 'package:vas_reporting/screen/task_track/task_track_service.dart';

part 'task_track_state.dart';

class TaskTrackCubit extends Cubit<TaskTrackState> {
  final TaskTrackService service;

  TaskTrackCubit(this.service) : super(TaskTrackInitial());

  Future<void> fetchTask() async {
    emit(TaskTrackLoading());
    try {
      final result = await service.getTaskTracker();

      if (result != null && result['status'] == "success") {
        final data = (result['data'] as List)
            .map((e) => TaskTrackResponse.fromJson(e))
            .toList();

        emit(TaskTrackSuccess(data));
      } else {
        emit(TaskTrackFailure("Data tidak ditemukan"));
      }
    } catch (e) {
      emit(TaskTrackFailure(e.toString()));
    }
  }







}
