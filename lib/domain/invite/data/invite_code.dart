class InviteCode {
  InviteCode({
    required this.id,
    required this.code,
    required this.useCount,
    required this.maxUseCount,
  });

  final String id;
  final String code;
  final int useCount;
  final int maxUseCount;
}
