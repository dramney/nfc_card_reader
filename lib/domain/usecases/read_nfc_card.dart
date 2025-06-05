import '../repositories/nfc_repository.dart';

class ReadNfcCard {
  final NfcRepository repository;

  ReadNfcCard(this.repository);

  Future<String> call() async {
    return await repository.readCardId();
  }
}
