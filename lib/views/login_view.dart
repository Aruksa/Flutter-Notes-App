import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilot/constants/routes.dart';
import '../firebase_options.dart';

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
                    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email,
                        password: password
                    );
                    print(userCredential);
                    Navigator.of(context).pushNamedAndRemoveUntil('/pilot/', (route) => false,);
                  } on FirebaseAuthException catch(e) {
                    if (e.code == "INVALID_LOGIN_CREDENTIALS") {
                      print("Invalid Credentials");
                    }
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

