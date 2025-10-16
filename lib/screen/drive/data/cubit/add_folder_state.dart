part of 'add_folder_cubit.dart';

abstract class AddFolderState extends Equatable {
  const AddFolderState();

  @override
  List<Object?> get props => [];
}

class AddFolderInitial extends AddFolderState {}

class AddFolderLoading extends AddFolderState {}

class AddFolderSuccess extends AddFolderState {
  final String message;
  final dynamic data;

  const AddFolderSuccess({required this.message, this.data});

  @override
  List<Object?> get props => [message, data];
}

class AddFolderFailure extends AddFolderState {
  final String message;

  const AddFolderFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
