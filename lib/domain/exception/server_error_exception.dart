class ServerErrorException implements Exception {
  ServerErrorException(this.originalException);

  final Object originalException;
}
