class LinkedinConfig {
  const LinkedinConfig._(
    this.clientId,
    this.clientSecret,
    this.redirectUri,
  );

  const LinkedinConfig.dev()
      : this._(
          '78fykr4kduc9wz',
          'tjU5SVMOOqugEgjc',
          'https://app.dev.informed.so/api/auth/callback/linkedin',
        );

  const LinkedinConfig.staging()
      : this._(
          '78fykr4kduc9wz',
          'tjU5SVMOOqugEgjc',
          'https://app.staging.informed.so/api/auth/callback/linkedin',
        );

  const LinkedinConfig.prod()
      : this._(
          '78fykr4kduc9wz',
          'tjU5SVMOOqugEgjc',
          'https://app.informed.so/api/auth/callback/linkedin',
        );

  final String clientId;
  final String clientSecret;
  final String redirectUri;
}
