import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                        email: email,
                        password: password
                    );
                    print(userCredential);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == "weak-password") {
                      print("Weak Password");
                    }
                    else if (e.code == "email-already-in-use") {
                      print("This email is already in use");
                    }
                    else if (e.code == "invalid-email"){
                      print("This email is invalid");
                    }
                  }
                },
                child: const Text("Register")

            ),
          ),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/login/',
                    (route) => false
            );
          }
              , child: const Text("Not a New User? Login Here!")
          )
        ],
      ),
    );
  }
}



