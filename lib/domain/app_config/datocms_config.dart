class DatoCMSConfig {
  const DatoCMSConfig._({
    required this.datoCMSUrl,
    required this.releaseNotesKey,
    required this.legalPagesKey,
  });

  const DatoCMSConfig.global()
      : this._(
          datoCMSUrl: 'https://graphql.datocms.com',
          releaseNotesKey: '1ecd2461c830b09d98d34b7cc9cd25',
          legalPagesKey: '9374c71d76037db54b450d2510de26',
        );

  final String datoCMSUrl;
  final String releaseNotesKey;
  final String legalPagesKey;
}
