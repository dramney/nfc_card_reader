import 'package:injectable/injectable.dart';

import '../entities/card_reader.dart';
import '../repositories/card_reader_repository.dart';

@lazySingleton
class GetAllCardReaders {
  final CardReaderRepository repository;

  GetAllCardReaders(this.repository);

  Future<List<CardReader>> call() async {
    return await repository.getAllCardReaders();
  }
}
