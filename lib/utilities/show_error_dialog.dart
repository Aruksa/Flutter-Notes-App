import 'package:flutter/material.dart';


Future<void> showErrorDialog(       //overlays are too complicated so we using this instead
    BuildContext context,
    String text,
    ) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Invalid Credentials!"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      }
  );
}