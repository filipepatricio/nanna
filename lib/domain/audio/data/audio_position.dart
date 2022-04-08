class AudioPosition {
  AudioPosition({
    required this.audioItemID,
    required this.position,
    required this.totalDuration,
  });

  final String audioItemID;
  final Duration position;
  final Duration totalDuration;
}
