import 'package:flutter/material.dart';
import 'package:pilot/services/auth/auth_service.dart';
import 'package:pilot/services/crud/pilot_service.dart';
import 'package:sqflite/sqflite.dart';

class NewPilotView extends StatefulWidget {
  const NewPilotView({super.key});

  @override
  State<NewPilotView> createState() => _NewPilotViewState();
}

class _NewPilotViewState extends State<NewPilotView> {
  DatabasePilot? _pilot;
  late final PilotService _pilotService; //to not announce factory function again and again
  late final TextEditingController _textEditingController;

  @override
  void initState () {
    _pilotService = PilotService();
    _textEditingController = TextEditingController();
    super.initState();
  } // need initstate to dispose???

  void _textControllerListener() async {
    final pilot = _pilot;
    if (pilot == null) {
      return;
    }
    final text = _textEditingController.text;
    await _pilotService.updatePilot(
        pilot: pilot, text: text
    );
  }

  void _setupTextControllerListener() {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }

  Future<DatabasePilot>createNewPilot() async {

    final existingPilot = _pilot;
    if (existingPilot != null) {
      return existingPilot;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _pilotService.getUser(email: email);
    return await _pilotService.createPilot(owner: owner);

  }

  void _deletePilotIfTextIsEmpty() {
    final pilot = _pilot;
    if (_textEditingController.text.isEmpty && pilot != null) {
      _pilotService.deletePilot(id: pilot.id);
    }
  }

  void _savePilotIfTextNotEmpty() async {
    final pilot = _pilot;
    final text = _textEditingController.text;
    if (pilot!= null && text.isNotEmpty) {
      await _pilotService.updatePilot(
          pilot: pilot,
          text: text,
      );
    }
  }

  @override
  void dispose () {
    _deletePilotIfTextIsEmpty();
    _savePilotIfTextNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Pilot'),
      ),
      body: FutureBuilder(
        future: createNewPilot(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _pilot = snapshot.data as DatabasePilot?;
              _setupTextControllerListener();
              return TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline, //have enter key??
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start typing your note...',
                ),
              );
              break;
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
