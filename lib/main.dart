import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilot/constants/routes.dart';
import 'package:pilot/views/login_view.dart';
import 'package:pilot/views/register_view.dart';
import 'package:pilot/views/verify_email_view.dart';
import 'firebase_options.dart';
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
      pilotRoute: (context) => const PilotView(),

    },
  ),
  );
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

@override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot){
        switch (snapshot.connectionState){

          case ConnectionState.done:
          final user = FirebaseAuth.instance.currentUser;
          if (user!= null) {
            if (user.emailVerified) {
              return const PilotView();
            } else {
              return const VerifyEmailView();
            }
          } else {
            return const LoginView();
          }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }

}

enum MenuAction {logout}

class PilotView extends StatefulWidget {
  const PilotView({super.key});

  @override
  State<PilotView> createState() => _PilotViewState();
}

class _PilotViewState extends State<PilotView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async  {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Icon(Icons.logout, color: Colors.pinkAccent),
              ),
              ];
            },
          )
        ],
      ),
      body: const Text("Hello World!"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {

  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign Out!"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop(false);

            }, child: const Text("Cancel")),
            TextButton(onPressed: () {
              Navigator.of(context).pop(true);
            }, child: const Text("Logout")),
          ],
        );
    },
  ).then((value) => value ?? false);
}



