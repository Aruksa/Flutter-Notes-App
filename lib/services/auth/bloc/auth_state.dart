
import 'package:flutter/material.dart';
import 'package:pilot/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState{
  const AuthStateUninitialized();
}

class AuthStateLoggedIn extends AuthState{
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState{
  const AuthStateNeedsVerification();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(this.exception);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin{
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [exception, isLoading];
}




