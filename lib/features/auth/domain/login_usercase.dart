import '../data/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<bool> execute(String email, String password) {
    return repository.login(email, password);
  }
}
