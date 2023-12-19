import 'package:flutter/material.dart';
import 'package:pilot/services/auth/auth_service.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import 'dart:developer' as devtools show log;
import '../../services/crud/pilot_service.dart';
import '../../main.dart';

class PilotView extends StatefulWidget {
  const PilotView({super.key});

  @override
  State<PilotView> createState() => _PilotViewState();
}

class _PilotViewState extends State<PilotView> {
  late final PilotService _pilotService;
  String get userEmail => AuthService.firebase().currentUser!.email!; //force unwrap??

  @override
  void initState() {
    _pilotService = PilotService(); //importing pilot_service pura ekta instance
    _pilotService.open();
    super.initState();
  }

  @override
  void dispose() {
    _pilotService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Pilots"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newPilotRoute);
              },
              icon: const Icon(Icons.add)),
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
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Icon(Icons.logout, color: Colors.pinkAccent),
                ),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _pilotService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _pilotService.allPilots,
                  builder: (context,snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return const Text("Waiting for all pilots...");
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
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