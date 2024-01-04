import 'package:flutter/material.dart';
import 'package:pilot/constants/routes.dart';
import 'package:pilot/services/auth/auth_service.dart';
import 'package:pilot/views/login_view.dart';
import 'package:pilot/views/notes/create_update_note_view.dart';
import 'package:pilot/views/notes/notes_view.dart';
import 'package:pilot/views/register_view.dart';
import 'package:pilot/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.pink,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      noteRoute: (context) => const NoteView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );  //runApp ending
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

@override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot){
        switch (snapshot.connectionState){
          case ConnectionState.done:
          final user = AuthService.firebase().currentUser;
          if (user!= null) {
            if (user.isEmailVerified) {
              return const NoteView();
            }
            else {
              return const VerifyEmailView();
            }
          }
          else {
            return const LoginView();
          }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

