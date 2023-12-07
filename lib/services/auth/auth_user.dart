import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';  //as FirebaseAuth show User;

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified});

  factory AuthUser.fromFirebase(User user) => AuthUser(isEmailVerified: user.emailVerified);

}
