import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import '../../domain/repositories/nfc_repository.dart';

class NfcRepositoryImpl implements NfcRepository {
  @override
  Future<String> readCardId() async {
    // 1. Перевірка статусу NFC
    final availability = await FlutterNfcKit.nfcAvailability;

    if (availability != NFCAvailability.available) {
      throw Exception("NFC вимкнено або не підтримується на цьому пристрої.");
    }

    // 2. Спроба прочитати картку
    try {
      final tag = await FlutterNfcKit.poll();
      return tag.id;
    } catch (e) {
      throw Exception("Не вдалося зчитати NFC: $e");
    } finally {
      // Завжди зупиняємо сесію
      await FlutterNfcKit.finish();
    }
  }
}
