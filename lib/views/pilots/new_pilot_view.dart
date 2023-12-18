

import 'package:flutter/material.dart';

class NewPilotView extends StatefulWidget {
  const NewPilotView({super.key});

  @override
  State<NewPilotView> createState() => _NewPilotViewState();
}

class _NewPilotViewState extends State<NewPilotView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Pilot'),
      ),
      body: const Text('Write in your new pilot here....'),
    );
  }
}
