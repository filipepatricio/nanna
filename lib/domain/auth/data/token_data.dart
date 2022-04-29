class TokenData {
  const TokenData({
    required this.uuid,
    this.email,
    this.firstName,
    this.lastName,
  });

  final String uuid;
  final String? email;
  final String? firstName;
  final String? lastName;
}
