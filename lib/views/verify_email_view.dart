import "package:flutter/material.dart";
import "package:pilot/services/auth/auth_service.dart";
import "../constants/routes.dart";

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email!"),
      ),
      body: Column(children: [
        const Text("Email verification is sent. Please open mail to verify your account"),
        const Text("If you haven't received a verification email, press the button below!"),
        TextButton(onPressed: () async {
          await AuthService.firebase().sendEmailVerification();

        },child: const Text("Send Email Verification :)"),
        ),
        TextButton(onPressed: () async {
          await AuthService.firebase().logOut();
          Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
        },child: const Text("Restart!"),
        )
      ],
      ),
    );
  }
}