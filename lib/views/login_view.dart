import 'package:flutter/material.dart';
import 'package:pilot/constants/routes.dart';
import 'package:pilot/services/auth/auth_exceptions.dart';
import 'package:pilot/services/auth/auth_service.dart';
import 'package:pilot/utilities/dialogs/error_dialog.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() { //initState() is a method that is called once when the Stateful Widget is inserted in the widget tree
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          Card(
            child: TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Type Email Here",
              ),
            ),
          ),
          Card(
            child: TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: "Type Password Here",
              ),
            ),
          ),
          Card(
            child: TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try{
                    await AuthService.firebase().logIn(
                        email: email,
                        password: password
                    );
                    final user = AuthService.firebase().currentUser;
                    if (user?.isEmailVerified == true){
                      Navigator.of(context).pushNamedAndRemoveUntil(noteRoute, (route) => false);
                    }
                    else {
                      Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                    }
                  } on InvalidCredentialsAuthException {
                    await showErrorDialog(context, "Invalid Login Credentials",);
                  } on GenericAuthException {
                    await showErrorDialog(context, "Authentication Error",);
                  }
                },
                child: const Text("Login"),
            ),
          ),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                    (route) => false
            );
          },
            child: const Text("Not Registered Yet? Register!"),
          )
        ],
      ),
    );
  }
}

