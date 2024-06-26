class AudioPosition {
  AudioPosition({
    required this.audioItemID,
    required this.position,
    required this.totalDuration,
  });

  final String audioItemID;
  final Duration position;
  final Duration totalDuration;

  AudioPosition copyWith({
    String? audioItemID,
    Duration? position,
    Duration? totalDuration,
  }) {
    return AudioPosition(
      audioItemID: audioItemID ?? this.audioItemID,
      position: position ?? this.position,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }
}
