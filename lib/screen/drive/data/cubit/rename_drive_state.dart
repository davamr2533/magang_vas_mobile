part of 'rename_drive_cubit.dart';

abstract class RenameDriveState extends Equatable {
  const RenameDriveState();

  @override
  List<Object?> get props => [];
}

class RenameDriveInitial extends RenameDriveState {}

class RenameDriveLoading extends RenameDriveState {}

class RenameDriveSuccess extends RenameDriveState {
  final String message;
  final dynamic data;

  const RenameDriveSuccess({required this.message, this.data});

  @override
  List<Object?> get props => [message, data];
}

class RenameDriveFailure extends RenameDriveState {
  final String message;

  const RenameDriveFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
