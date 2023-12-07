

import 'package:flutter/material.dart';
import 'package:pilot/services/auth/auth_service.dart';
import '../constants/routes.dart';
import '../enums/menu_action.dart';
import 'dart:developer' as devtools show log;

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
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
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
          },
            child: const Text("Cancel")),
          TextButton(onPressed: () {
            Navigator.of(context).pop(true);
          },
            child: const Text("Logout")),
        ],
      );
    },
  ).then((value) => value ?? false);
}