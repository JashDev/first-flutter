import '../data/auth_repository.dart';
import '../data/models/sign_in_dto.dart';
import '../data/models/user_logged_dto.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserLoggedDto?> execute(String email, String password) {
    final signInDto = SignInDto(email: email, password: password);
    return repository.login(signInDto: signInDto);
  }
}
