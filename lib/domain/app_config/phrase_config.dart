class PhraseConfig {
  const PhraseConfig._(
    this.phraseDistributionID,
    this.phraseEnvironmentID,
  );

  const PhraseConfig.dev()
      : this._(
          '82480f2ca85c850e9fa9c9bc5296361d',
          'r4u6hPF5-18lrAxbaf1XxQKHjd8KhSfEft9ciAphz4k',
        );

  const PhraseConfig.prod()
      : this._(
          '82480f2ca85c850e9fa9c9bc5296361d',
          '8be-JyB_XCZy4vo5egzsQPcZW11_xOB3LqcvqybOu80',
        );

  final String phraseDistributionID;
  final String phraseEnvironmentID;
}
