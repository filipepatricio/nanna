class FirebaseUnknownException implements Exception {
  FirebaseUnknownException(this.code, this.message);

  final String code;
  final String? message;

  @override
  String toString() {
    return 'FirebaseUnknownException{code: $code, message: $message}';
  }
}
