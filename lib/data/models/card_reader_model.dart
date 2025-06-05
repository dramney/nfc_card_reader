import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/card_reader.dart';

class CardReaderModel extends CardReader {
  CardReaderModel({
    required super.id,
    required super.roomName,
    required super.allowedGroupIds,
  });

  factory CardReaderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CardReaderModel(
      id: doc.id,
      roomName: data['roomName'] ?? '',
      allowedGroupIds: List<String>.from(data['allowedGroupIds'] ?? []),
    );
  }
}
