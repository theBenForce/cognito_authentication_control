part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AuthenticationLoadSavedUser extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationLoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  AuthenticationLoginEvent({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthenticationResetPasswordEvent extends AuthenticationEvent {
  final String email;
  final String oldPassword;
  final String password;

  AuthenticationResetPasswordEvent(
      {@required this.email,
      @required this.oldPassword,
      @required this.password});

  @override
  List<Object> get props => [email, oldPassword, password];
}
