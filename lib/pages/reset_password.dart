import 'package:cognito_authentication_control/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordPage extends StatelessWidget {
  final String email;
  final String oldPassword;

  const ResetPasswordPage({Key key, @required this.email, this.oldPassword})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final oldPasswordController =
        TextEditingController.fromValue(TextEditingValue(text: oldPassword));
    final newPasswordController = TextEditingController();

    return Scaffold(
      body: Center(
          child: ConstrainedBox(
        constraints: BoxConstraints.tightForFinite(width: 350.0),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Text("Login",
                      style: Theme.of(context).textTheme.headline6),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                        isDense: true),
                    readOnly: true,
                    controller: TextEditingController.fromValue(
                        TextEditingValue(text: email)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Old Password",
                        isDense: true),
                    obscureText: true,
                    controller: oldPasswordController,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "New Password",
                      isDense: true),
                  obscureText: true,
                  controller: newPasswordController,
                ),
                ButtonBar(
                  children: [
                    RaisedButton(
                      onPressed: () => context.bloc<AuthenticationBloc>().add(
                          AuthenticationResetPasswordEvent(
                              email: email,
                              oldPassword: oldPasswordController.value.text,
                              password: newPasswordController.value.text)),
                      child: Text("Reset Password"),
                    )
                  ],
                )
              ],
            ),
          ),
        )),
      )),
    );
  }
}
