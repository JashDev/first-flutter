class SignInDto {
  final String email;
  final String password;
  final String channel;

  SignInDto({
    required this.email,
    required this.password,
    this.channel = 'whatsapp',
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'channel': channel,
    };
  }
}