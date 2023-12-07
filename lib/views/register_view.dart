import 'package:flutter/material.dart';
import 'package:pilot/constants/routes.dart';
import 'package:pilot/services/auth/auth_exceptions.dart';
import 'package:pilot/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;
import '../utilities/show_error_dialog.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override //@override-> the function is also defined in a parent class, it is being redefined to do something else in the current class
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;  //late-> indicate that a non-nullable variable will be initialized later in the code
  late final TextEditingController _password; //final-> variable initialized at runtime and can only be assigned for a single time

  @override
  void initState() {
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
        title: const Text("Register"),
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
                  try {
                    await AuthService.firebase().createUser(
                        email: email,
                        password: password
                    );
                    // devtools.log(userCredential.toString());
                    //final user = AuthService.firebase().currentUser;
                    AuthService.firebase().sendEmailVerification(); //ar user eikhane thakbe na likha
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  } on WeakPasswordAuthException {
                    await showErrorDialog(context, "Weak Password",);
                  } on EmailAlreadyInUseAuthException {
                    await showErrorDialog(context, "Email already in use!",);
                  } on InvalidEmailAuthException {
                    await showErrorDialog(context, "Invalid Email D:",);
                  } on GenericAuthException {
                    await showErrorDialog(context, "Failed to register!");
                  }
                },
                child: const Text("Register")
            ),
          ),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                    (route) => false
            );
          },
            child: const Text("Not a New User? Login Here!")
          )
        ],
      ),
    );
  }
}






