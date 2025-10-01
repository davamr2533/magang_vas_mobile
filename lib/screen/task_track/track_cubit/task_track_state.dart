part of 'task_track_cubit.dart';

abstract class TaskTrackState extends Equatable {
  const TaskTrackState();

  @override
  List<Object?> get props => [];
}

class TaskTrackInitial extends TaskTrackState {}

class TaskTrackLoading extends TaskTrackState {}

class TaskTrackFailure extends TaskTrackState {
  final String message;
  const TaskTrackFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskTrackSuccess extends TaskTrackState {
  final List<TaskTrackResponse> tasks;
  const TaskTrackSuccess(this.tasks);

  @override
  List<Object?> get props => [tasks];
}
