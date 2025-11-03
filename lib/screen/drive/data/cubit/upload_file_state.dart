part of 'upload_file_cubit.dart';

abstract class UploadFileState extends Equatable {
  const UploadFileState();

  @override
  List<Object?> get props => [];
}

class UploadFileInitial extends UploadFileState {}

class UploadFileLoading extends UploadFileState {}

class UploadFileSuccess extends UploadFileState {
  final String message;
  final dynamic data;

  const UploadFileSuccess({required this.message, this.data});

  @override
  List<Object?> get props => [message, data];
}

class UploadFileFailure extends UploadFileState {
  final String message;

  const UploadFileFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
