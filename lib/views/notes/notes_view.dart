import 'package:flutter/material.dart';
import 'package:pilot/services/auth/auth_service.dart';
import 'package:pilot/services/cloud/cloud_note.dart';
import 'package:pilot/services/cloud/firebase_cloud_storage.dart';
import 'package:pilot/services/crud/notes_services.dart';
import 'package:pilot/utilities/dialogs/logout_dialog.dart';
import 'package:pilot/views/notes/notes_list_view.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../main.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final FirebaseCloudStorage _noteService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
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
      body: StreamBuilder(
          stream: _noteService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData)
                {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _noteService.deleteNote(documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const Text("Waiting for all notes");
                }
              default:
                return const CircularProgressIndicator();
            }
          }
      ),
    );
  }
}