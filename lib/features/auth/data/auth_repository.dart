import '../../../core/contants.dart';

class AuthRepository {
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // Simula una llamada a API
    return email == Constants.validEmail && password == Constants.validPassword;
  }
}
