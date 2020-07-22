import 'dart:async';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:cognito_authentication_control/models/user.dart';
import 'package:cognito_authentication_control/repositories/authentication.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserAuthenticationRepo _authenticationRepo;
  static User _user;

  AuthenticationBloc(this._authenticationRepo) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationLoadSavedUser) {
      if (_user == null) {
        _user = await _authenticationRepo.getCurrentUser();
      }
      if (_user != null) {
        yield AuthenticationSignedIn(user: _user);
      } else {
        yield AuthenticationInitial();
      }
    } else if (event is AuthenticationLoginEvent) {
      yield AuthenticationBusy("Signing in");
      try {
        _user = await _authenticationRepo.login(event.email, event.password);

        yield AuthenticationSignedIn(user: _user);
      } on CognitoClientException catch (e) {
        print("Failed to log in: ${e.message}");
        yield AuthenticationInitial(message: e.message);
      } on CognitoUserNewPasswordRequiredException catch (e) {
        print("Failed to log in: ${e.message}");
        yield AuthenticationPasswordResetRequired(
            email: event.email, oldPassword: event.password);
      } on CognitoUserException catch (e) {
        print("Failed to log in: ${e.message}");
        yield AuthenticationInitial(message: e.message);
      } catch (e) {
        print(e);
      }
    } else if (event is AuthenticationResetPasswordEvent) {
      yield AuthenticationBusy("Resetting password");
      try {
        var result = await _authenticationRepo.resetPassword(
            event.email, event.oldPassword, event.password);
      } catch (e) {
        print("Error resetting password: $e");
      }
    }
  }
}
