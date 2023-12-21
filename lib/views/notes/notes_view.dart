import 'package:flutter/material.dart';
import 'package:pilot/services/auth/auth_service.dart';
import 'package:pilot/services/crud/notes_services.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../main.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final NoteService _noteService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _noteService = NoteService();
    _noteService.open();
    super.initState();
  }

  @override
  void dispose() {
    _noteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(newNoteRoute);
          },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false,);
                    }
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Icon(Icons.logout, color: Colors.purple)
                  )
                ];
              }
          )
        ],
      ),
      body: FutureBuilder(
        future: _noteService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _noteService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const Text("Waiting for all notes");
                    default:
                      return const CircularProgressIndicator();
                  }
                }
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}