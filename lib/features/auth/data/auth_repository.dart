import 'package:flutter/material.dart';
import 'package:login_example/features/auth/data/auth_service.dart';
import 'package:login_example/features/auth/data/models/sign_in_dto.dart';

class AuthRepository {
  final _authService = AuthService();

  Future<bool> login({required SignInDto signInDto}) async {
    final response = await _authService.signIn(signInDto);

    debugPrint(response.toString());

    return false;
  }
}
