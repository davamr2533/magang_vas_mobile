part of 'form_cubit.dart';

abstract class FormHasState extends Equatable {
  const FormHasState();

  @override
  List<Object?> get props => [];
  List<Object?> get propsCustomer => [];
}

class FormInitial extends FormHasState {}

class FormResponseSuccess extends FormHasState {
  final FormResponse response;

  const FormResponseSuccess(this.response);

  @override
  List<Object?> get props => [response];
}


class FormLoading extends FormHasState {}

class FormFailure extends FormHasState {
  final String message;

  const FormFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogoutSucess extends FormHasState {}