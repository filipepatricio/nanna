class AudioFileLoadingException implements Exception {
  const AudioFileLoadingException(this.url, this.message);

  final String url;
  final String? message;

  @override
  String toString() {
    return '$runtimeType {url: $url, message: $message}';
  }
}
