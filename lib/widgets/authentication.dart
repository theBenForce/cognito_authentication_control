import 'package:cognito_authentication_control/bloc/authentication_bloc.dart';
import 'package:cognito_authentication_control/models/user.dart';
import 'package:cognito_authentication_control/pages/login_page.dart';
import 'package:cognito_authentication_control/pages/reset_password.dart';
import 'package:cognito_authentication_control/repositories/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAuthentication extends StatelessWidget {
  final Widget Function(BuildContext, User) builder;
  final UserAuthenticationRepo authentication;

  UserAuthentication(
      {Key key, @required this.builder, @required this.authentication})
      : super(key: key);

  static UserAuthentication of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<UserAuthentication>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(authentication)
        ..add(AuthenticationLoadSavedUser()),
      child: Builder(
          builder: (context) =>
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, authenticationState) {
                  if (authenticationState is AuthenticationBusy) {
                    return Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        if (authenticationState.message != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(authenticationState.message,
                                style: Theme.of(context).textTheme.bodyText2),
                          )
                      ],
                    ));
                  }

                  if (authenticationState is AuthenticationInitial) {
                    return LoginPage();
                  }

                  if (authenticationState
                      is AuthenticationPasswordResetRequired) {
                    return ResetPasswordPage(
                      email: authenticationState.email,
                      oldPassword: authenticationState.oldPassword,
                    );
                  }

                  if (authenticationState is AuthenticationSignedIn) {
                    return builder(context, authenticationState.user);
                  }

                  return ErrorWidget.withDetails(
                    message: "Unknown State",
                  );
                },
              )),
    );
  }
}
