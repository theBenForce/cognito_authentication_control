part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  final String message;

  AuthenticationInitial({this.message});

  @override
  List<Object> get props => [message];
}

class AuthenticationBusy extends AuthenticationState {
  final String message;

  AuthenticationBusy(this.message);

  @override
  List<Object> get props => [message];
}

class AuthenticationSignedIn extends AuthenticationState {
  final User user;

  AuthenticationSignedIn({@required this.user});

  @override
  List<Object> get props => [user];
}

class AuthenticationPasswordResetRequired extends AuthenticationState {
  final String email;
  final String oldPassword;

  AuthenticationPasswordResetRequired(
      {@required this.email, @required this.oldPassword});

  @override
  List<Object> get props => [email, oldPassword];
}
