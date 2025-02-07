class UserLoggedDto {
  final String lastName;
  final String userHash;
  final dynamic newDeviceMetadata;
  final dynamic ref2;
  final bool isCompany;
  final dynamic ref1;
  final String accessToken;
  final int expiresIn;
  final String referralCode;
  final String idToken;
  final String name;
  final String nextStep;
  final String tokenType;
  final bool isReferred;
  final bool newclient;
  final bool firstSignIn;
  final String email;
  final String refreshToken;
  final int signUpTimestamp;

  UserLoggedDto({
    required this.lastName,
    required this.userHash,
    required this.newDeviceMetadata,
    required this.ref2,
    required this.isCompany,
    required this.ref1,
    required this.accessToken,
    required this.expiresIn,
    required this.referralCode,
    required this.idToken,
    required this.name,
    required this.nextStep,
    required this.tokenType,
    required this.isReferred,
    required this.newclient,
    required this.firstSignIn,
    required this.email,
    required this.refreshToken,
    required this.signUpTimestamp,
  });

  /// Método `fromJson` para convertir un mapa JSON en una instancia de UserLoggedDto
  factory UserLoggedDto.fromJson(Map<String, dynamic> json) {
    return UserLoggedDto(
      lastName: json['lastName'] ?? '',
      userHash: json['userHash'] ?? '',
      newDeviceMetadata: json['newDeviceMetadata'],
      ref2: json['ref2'],
      isCompany: json['isCompany'] ?? false,
      ref1: json['ref1'],
      accessToken: json['accessToken'] ?? '',
      expiresIn: json['expiresIn'] ?? 0,
      referralCode: json['referralCode'] ?? '',
      idToken: json['idToken'] ?? '',
      name: json['name'] ?? '',
      nextStep: json['nextStep'] ?? '',
      tokenType: json['tokenType'] ?? '',
      isReferred: json['isReferred'] ?? false,
      newclient: json['newclient'] ?? false,
      firstSignIn: json['firstSignIn'] ?? false,
      email: json['email'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      signUpTimestamp: json['signUpTimestamp'] ?? 0,
    );
  }

  /// Método para convertir la instancia en un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'lastName': lastName,
      'userHash': userHash,
      'newDeviceMetadata': newDeviceMetadata,
      'ref2': ref2,
      'isCompany': isCompany,
      'ref1': ref1,
      'accessToken': accessToken,
      'expiresIn': expiresIn,
      'referralCode': referralCode,
      'idToken': idToken,
      'name': name,
      'nextStep': nextStep,
      'tokenType': tokenType,
      'isReferred': isReferred,
      'newclient': newclient,
      'firstSignIn': firstSignIn,
      'email': email,
      'refreshToken': refreshToken,
      'signUpTimestamp': signUpTimestamp,
    };
  }

  /// Método `copyWith` para crear una copia del objeto con valores actualizados
  UserLoggedDto copyWith({
    String? lastName,
    String? userHash,
    dynamic newDeviceMetadata,
    dynamic ref2,
    bool? isCompany,
    dynamic ref1,
    String? accessToken,
    int? expiresIn,
    String? referralCode,
    String? idToken,
    String? name,
    String? nextStep,
    String? tokenType,
    bool? isReferred,
    bool? newclient,
    bool? firstSignIn,
    String? email,
    String? refreshToken,
    int? signUpTimestamp,
  }) {
    return UserLoggedDto(
      lastName: lastName ?? this.lastName,
      userHash: userHash ?? this.userHash,
      newDeviceMetadata: newDeviceMetadata ?? this.newDeviceMetadata,
      ref2: ref2 ?? this.ref2,
      isCompany: isCompany ?? this.isCompany,
      ref1: ref1 ?? this.ref1,
      accessToken: accessToken ?? this.accessToken,
      expiresIn: expiresIn ?? this.expiresIn,
      referralCode: referralCode ?? this.referralCode,
      idToken: idToken ?? this.idToken,
      name: name ?? this.name,
      nextStep: nextStep ?? this.nextStep,
      tokenType: tokenType ?? this.tokenType,
      isReferred: isReferred ?? this.isReferred,
      newclient: newclient ?? this.newclient,
      firstSignIn: firstSignIn ?? this.firstSignIn,
      email: email ?? this.email,
      refreshToken: refreshToken ?? this.refreshToken,
      signUpTimestamp: signUpTimestamp ?? this.signUpTimestamp,
    );
  }
}