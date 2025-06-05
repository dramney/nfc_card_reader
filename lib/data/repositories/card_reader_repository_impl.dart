import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/card_reader.dart';
import '../../domain/repositories/card_reader_repository.dart';
import '../models/card_reader_model.dart';

class CardReaderRepositoryImpl implements CardReaderRepository {
  final FirebaseFirestore firestore;

  CardReaderRepositoryImpl(this.firestore);

  @override
  Future<List<CardReader>> getAllCardReaders() async {
    final snapshot = await firestore.collection('cardReaders').get();
    return snapshot.docs.map((doc) => CardReaderModel.fromFirestore(doc)).toList();
  }
}
