import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilot/services/auth/auth_exceptions.dart';
import 'package:pilot/services/auth/bloc/auth_event.dart';
import 'package:pilot/utilities/dialogs/error_dialog.dart';
import 'dart:developer' as devtools show log;
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override //@override-> the function is also defined in a parent class, it is being redefined to do something else in the current class
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email; //late-> indicate that a non-nullable variable will be initialized later in the code
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, "Weak Password",);
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, "Email already in use!",);
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Invalid Email D:",);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Failed to register!");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
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
                        context.read<AuthBloc>().add(AuthEventRegister(
                            email,
                            password),
                        );
                      },
                      child: const Text("Register")
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                  },
                    child: const Text("Not a New User? Login Here!")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}






