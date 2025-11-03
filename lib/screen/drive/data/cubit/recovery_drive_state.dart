part of 'recovery_drive_cubit.dart';

abstract class RecoveryDriveState extends Equatable {
  const RecoveryDriveState();

  @override
  List<Object?> get props => [];
}

class RecoveryDriveInitial extends RecoveryDriveState {}

class RecoveryDriveLoading extends RecoveryDriveState {}

class RecoveryDriveSuccess extends RecoveryDriveState {
  final String message;
  final dynamic data;

  const RecoveryDriveSuccess({required this.message, this.data});

  @override
  List<Object?> get props => [message, data];
}

class RecoveryDriveFailure extends RecoveryDriveState {
  final String message;

  const RecoveryDriveFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
