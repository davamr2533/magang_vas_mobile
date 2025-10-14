part of 'task_history_cubit.dart';

abstract class TaskHistoryState extends Equatable {
  const TaskHistoryState();

  @override
  List<Object?> get props => [];
}

class TaskHistoryInitial extends TaskHistoryState {}

class TaskHistoryLoading extends TaskHistoryState {}

class TaskHistoryFailure extends TaskHistoryState {
  final String message;
  const TaskHistoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskHistorySuccess extends TaskHistoryState {
  final List<TaskHistoryResponse> histories;
  const TaskHistorySuccess(this.histories);

  @override
  List<Object?> get props => [histories];
}
