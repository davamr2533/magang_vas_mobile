part of 'get_data_cubit.dart';

abstract class GetDataHasState extends Equatable {
  const GetDataHasState();

  @override
  List<Object?> get props => [];
  List<Object?> get propsCustomer => [];
}

class GetDataInitial extends GetDataHasState {}

class GetDataSuccess extends GetDataHasState {
  final GetDataResponse response;

  const GetDataSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ApprovalSuucess extends GetDataHasState {
  final FormResponse response;

  const ApprovalSuucess(this.response);

  @override
  List<Object?> get props => [response];
}

class GetDataVasSuccess extends GetDataHasState {
  final GetDataVasResponse response;

  const GetDataVasSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class GetDataUjiSuccess extends GetDataHasState {
  final GetDataUjiResponse response;

  const GetDataUjiSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class GetDataLoading extends GetDataHasState {}
class ApprovalLoading extends GetDataHasState {}
class GetDataVasLoading extends GetDataHasState {}
class GetDataUjiLoading extends GetDataHasState {}

class GetDataFailure extends GetDataHasState {
  final String message;

  const GetDataFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ApprovalFailure extends GetDataHasState {
  final String message;

  const ApprovalFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetDataVasFailure extends GetDataHasState {
  final String message;

  const GetDataVasFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetDataUjiFailure extends GetDataHasState {
  final String message;

  const GetDataUjiFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogoutSucess extends GetDataHasState {}