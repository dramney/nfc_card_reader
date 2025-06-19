import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'dart:typed_data';
import '../../domain/repositories/nfc_repository.dart';

class NfcRepositoryImpl implements NfcRepository {
  @override
  Future<String> readCardId() async {
    // Перевіряємо доступність NFC
    final availability = await NfcManager.instance.isAvailable();

    if (!availability) {
      throw Exception("NFC вимкнено або не підтримується на цьому пристрої.");
    }

    String? result;
    Exception? error;

    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            // Пробуємо ISO7816 (для HCE сервісів)
            final iso7816 = IsoDep.from(tag);
            if (iso7816 == null) {
              // Спочатку пробуємо зчитати NDEF дані (для звичайних карток)
              final ndef = Ndef.from(tag);
              if (ndef != null) {
                final message = await ndef.read();
                if (message.records.isNotEmpty) {
                  final record = message.records.first;
                  // Пропускаємо код мови (перші 3 байти)
                  final payload = String.fromCharCodes(record.payload.skip(3));
                  result = payload;
                  return;
                }
              }

            }
            if (iso7816 != null) {
              try {
                // Вибираємо наш AID (F222222222)
                final selectCommand = Uint8List.fromList([
                  0x00, 0xA4, 0x04, 0x00, // CLA INS P1 P2
                  0x05, // LC (довжина AID)
                  0xF2, 0x22, 0x22, 0x22, 0x22, // AID
                  0x00  // LE
                ]);

                print("Sending SELECT command: ${selectCommand.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}");
                final selectResponse = await iso7816.transceive(data: selectCommand);
                print("SELECT response: ${selectResponse.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}");

                // Перевіряємо чи успішно вибрано додаток (90 00)
                if (selectResponse.length >= 2 &&
                    selectResponse[selectResponse.length - 2] == 0x90 &&
                    selectResponse[selectResponse.length - 1] == 0x00) {

                  // Запитуємо дані картки
                  final getDataCommand = Uint8List.fromList([
                    0x00, 0xCA, 0x00, 0x00, // GET DATA command
                    0x00  // LE
                  ]);

                  print("Sending GET DATA command: ${getDataCommand.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}");
                  final dataResponse = await iso7816.transceive(data: getDataCommand);
                  print("GET DATA response: ${dataResponse.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}");

                  // Перевіряємо чи успішно отримано дані
                  if (dataResponse.length >= 2 &&
                      dataResponse[dataResponse.length - 2] == 0x90 &&
                      dataResponse[dataResponse.length - 1] == 0x00) {

                    // Витягуємо дані (без останніх 2 байтів статусу)
                    final cardData = dataResponse.sublist(0, dataResponse.length - 2);
                    result = String.fromCharCodes(cardData);
                    print("Card ID from HCE: $result");
                  } else {
                    // Пробуємо простий запит
                    final simpleCommand = Uint8List.fromList([0x80, 0x00, 0x00, 0x00, 0x00]);
                    print("Sending simple command: ${simpleCommand.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}");
                    final simpleResponse = await iso7816.transceive(data: simpleCommand);
                    print("Simple response: ${simpleResponse.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}");

                    if (simpleResponse.length >= 2 &&
                        simpleResponse[simpleResponse.length - 2] == 0x90 &&
                        simpleResponse[simpleResponse.length - 1] == 0x00) {
                      final cardData = simpleResponse.sublist(0, simpleResponse.length - 2);
                      result = String.fromCharCodes(cardData);
                      print("Card ID from simple command: $result");
                    }
                  }
                }
              } catch (isoError) {
                print("ISO-DEP communication error: $isoError");
                // Continue to try physical tag reading
              }
            }

            // Якщо HCE не спрацював, пробуємо отримати ID фізичної картки
            if (result == null) {
              final tagId = tag.data['nfca']?['identifier'] ??
                  tag.data['nfcb']?['identifier'] ??
                  tag.data['nfcf']?['identifier'] ??
                  tag.data['nfcv']?['identifier'];

              if (tagId != null) {
                final id = (tagId as Uint8List)
                    .map((e) => e.toRadixString(16).padLeft(2, '0'))
                    .join(':');
                result = id;
                print("Physical tag ID: $result");
              }
            }

            if (result == null) {
              throw Exception("Не вдалося отримати дані з картки");
            }

          } catch (e) {
            print("Error processing card: $e");
            error = Exception("Помилка обробки картки: $e");
          }
        },
      );

      // Чекаємо результат максимум 10 секунд
      for (int i = 0; i < 100; i++) {
        await Future.delayed(Duration(milliseconds: 100));
        if (result != null || error != null) {
          break;
        }
      }

      if (error != null) {
        throw error!;
      }

      if (result == null) {
        throw Exception("Час очікування картки вичерпано");
      }

      return result!;

    } catch (e) {
      print("NFC read error: $e");
      throw Exception("Не вдалося зчитати NFC картку: $e");
    } finally {
      await NfcManager.instance.stopSession();
    }
  }
}