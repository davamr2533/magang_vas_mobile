part of 'delete_drive_cubit.dart';

abstract class DeleteDriveState extends Equatable {
  const DeleteDriveState();

  @override
  List<Object?> get props => [];
}

class DeleteDriveInitial extends DeleteDriveState {}

class DeleteDriveLoading extends DeleteDriveState {}

class DeleteDriveSuccess extends DeleteDriveState {
  final String message;
  final dynamic data;

  const DeleteDriveSuccess({required this.message, this.data});

  @override
  List<Object?> get props => [message, data];
}

class DeleteDriveFailure extends DeleteDriveState {
  final String message;

  const DeleteDriveFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
