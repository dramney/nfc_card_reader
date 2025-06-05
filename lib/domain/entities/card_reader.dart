class CardReader {
  final String id;
  final String roomName;
  final List<String> allowedGroupIds;

  CardReader({
    required this.id,
    required this.roomName,
    required this.allowedGroupIds,
  });
}
