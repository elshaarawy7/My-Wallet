class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final String? name;

  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    this.name,
  });

  factory LoginResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    // API might wrap response in a 'data' key
    final Map<String, dynamic> data =
        json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;

    return LoginResponseModel(
      accessToken: (data['accessToken'] ?? data['access_token'] ?? '').toString(),
      refreshToken: (data['refreshToken'] ?? data['refresh_token'] ?? '').toString(),
      name: (data['name'] ??
              data['fullName'] ??
              data['username'] ??
              (data['user'] is Map<String, dynamic>
                  ? (data['user'] as Map<String, dynamic>)['name']
                  : null))
          ?.toString(),
    );
  }
}