part of 'starred_cubit.dart';

abstract class StarredState extends Equatable {
  const StarredState();

  @override
  List<Object?> get props => [];
}
class StarredInitial extends StarredState {}

class StarredLoading extends StarredState {}

class StarredSuccess extends StarredState {
  final String message;
  final dynamic data;

  const StarredSuccess({required this.message, this.data});

  @override
  List<Object?> get props => [message, data];
}

class StarredFailure extends StarredState {
  final String message; // ✅ ubah dari errorMessage ke message
  StarredFailure(this.message);
}
