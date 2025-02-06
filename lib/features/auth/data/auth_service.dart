import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_example/core/network/api_service.dart';
import 'models/sign_in_dto.dart';

class AuthService {
  final ApiService apiServiceUnauthenticated = ApiService(requiresAuth: false);
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> signIn(SignInDto data) async {
    try {
      final response = await apiServiceUnauthenticated.post(
        '/customer/login',
        data.toJson(),
        headers: {
          'X-API-VERSION': '2',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data;
        log('✅ Login exitoso: $responseData');

        // === WhiteList Users ===
        if (responseData.containsKey('idToken')) {
          await _updateTokens(responseData);
          await _storage.write(key: 'is_white_list_user', value: 'true');
        } else {
          await _storage.write(key: 'sign_in_challenge', value: responseData.toString());
        }
        return responseData;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error en signIn: $e');
      return null;
    }
  }

  Future<void> _updateTokens(Map<String, dynamic> data) async {
    if (data.containsKey('idToken') && data.containsKey('accessToken') && data.containsKey('refreshToken')) {
      await _storage.write(key: 'id_token', value: data['idToken']);
      await _storage.write(key: 'access_token', value: data['accessToken']);
      await _storage.write(key: 'refresh_token', value: data['refreshToken']);
    }
  }
}

