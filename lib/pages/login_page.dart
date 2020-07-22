import 'package:cognito_authentication_control/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ConstrainedBox(
        constraints: BoxConstraints.tightForFinite(width: 350.0),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: loginForm(context),
        )),
      )),
    );
  }

  Widget loginForm(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Text("Login", style: Theme.of(context).textTheme.headline6),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "email",
                  icon: Icon(Icons.email),
                  isDense: true),
              controller: emailController,
            ),
          ),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "password",
                icon: Icon(Icons.lock),
                isDense: true),
            obscureText: true,
            controller: passwordController,
          ),
          ButtonBar(
            children: [
              RaisedButton(
                onPressed: () => context.bloc<AuthenticationBloc>().add(
                    AuthenticationLoginEvent(
                        email: emailController.value.text,
                        password: passwordController.value.text)),
                child: Text("Login"),
              )
            ],
          )
        ],
      ),
    );
  }
}
