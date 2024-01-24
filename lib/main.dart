import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilot/constants/routes.dart';
import 'package:pilot/services/auth/auth_service.dart';
import 'package:pilot/services/auth/bloc/auth_bloc.dart';
import 'package:pilot/services/auth/bloc/auth_event.dart';
import 'package:pilot/services/auth/bloc/auth_state.dart';
import 'package:pilot/services/auth/firebase_auth_provider.dart';
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
    home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
    ),
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
  context.read<AuthBloc>().add(const AuthEventInitialize());
  return BlocBuilder(builder: (context, state) {
    if (state is AuthStateLoggedIn) {
      return const NoteView();
    } else if (state is AuthStateNeedsVerification) {
      return const VerifyEmailView();
    } else if (state is AuthStateLoggedOut) {
      return const LoginView();
    } else {
      return const Scaffold(
        body: CircularProgressIndicator(),
        );
      }
    },);
  }
}

