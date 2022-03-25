import 'dart:io';

class AudioItem {
  AudioItem({
    required this.file,
    required this.title,
    required this.publisher,
    this.imageUrl,
  });

  final File file;
  final String title;
  final String publisher;
  final String? imageUrl;
}
