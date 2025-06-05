import '../entities/card_reader.dart';

abstract class CardReaderRepository {
  Future<List<CardReader>> getAllCardReaders();
}
