part of 'add_to_trash_cubit.dart';

abstract class AddToTrashState extends Equatable {
  const AddToTrashState();

  @override
  List<Object?> get props => [];
}

class AddToTrashInitial extends AddToTrashState {}

class AddToTrashLoading extends AddToTrashState {}

class AddToTrashSuccess extends AddToTrashState {
  final String message;
  final dynamic data;

  const AddToTrashSuccess({required this.message, this.data});

  @override
  List<Object?> get props => [message, data];
}

class AddToTrashFailure extends AddToTrashState {
  final String message;

  const AddToTrashFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
