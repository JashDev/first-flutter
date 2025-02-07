import 'package:flutter/material.dart';
import 'package:login_example/features/auth/data/auth_service.dart';
import 'package:login_example/features/auth/data/models/sign_in_dto.dart';
import 'package:login_example/features/auth/data/models/user_logged_dto.dart';

class AuthRepository {
  final _authService = AuthService();

  Future<UserLoggedDto?> login({required SignInDto signInDto}) async {
    try {
      final response = await _authService.signIn(signInDto);

      debugPrint(response.toString());
      return UserLoggedDto.fromJson(response!);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
