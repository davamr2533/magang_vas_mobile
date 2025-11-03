
part of 'get_drive_cubit.dart';

@immutable
abstract class DriveState extends Equatable {
  const DriveState();

  @override
  List<Object> get props => [];
}

/// State Awal
class DriveInitial extends DriveState {}

/// State ketika sedang memuat data
class DriveLoading extends DriveState {}

/// State ketika berhasil mendapatkan data drive
class DriveDataSuccess extends DriveState {
  final GetDataDriveResponse driveData;

  const DriveDataSuccess(this.driveData);

  @override
  List<Object> get props => [driveData];
}

/// State ketika gagal mendapatkan data drive
class DriveDataFailure extends DriveState {
  final String message;

  const DriveDataFailure({required this.message});

  @override
  List<Object> get props => [message];
}