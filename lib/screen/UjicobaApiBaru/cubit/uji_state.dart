part of 'uji_cubit.dart';

abstract class UjiState extends Equatable {
  const UjiState();

  @override
  List<Object?> get props => [];
}

class UjiInitial extends UjiState {}

class UjiLoading extends UjiState {}

class UjiFailure extends UjiState {
  final String message;
  const UjiFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UjiSuccess extends UjiState {
  final List<UjiResponse> tasks;
  const UjiSuccess(this.tasks);

  @override
  List<Object?> get props => [tasks];
}
