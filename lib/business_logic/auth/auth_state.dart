import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
  @override
  List<Object?> get props => [];
}

class AuthStateLoaded extends AuthState {
  final String messgeDataLoaded;
  const AuthStateLoaded({required this.messgeDataLoaded});

  @override
  List<Object?> get props => [messgeDataLoaded];
}

class AuthStateError extends AuthState {
  final String errorMessage;
  const AuthStateError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

// class AuthStateInternet extends AuthState {
//   const AuthStateInternet();

//   @override
//   List<Object?> get props => [];
// }
