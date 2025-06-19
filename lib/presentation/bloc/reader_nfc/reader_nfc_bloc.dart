import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../../../domain/usecases/read_nfc_card.dart';
import 'reader_nfc_event.dart';
import 'reader_nfc_state.dart';

class ReaderNfcBloc extends Bloc<ReaderNfcEvent, ReaderNfcState> {
  final ReadNfcCard readNfcCard;

  ReaderNfcBloc(this.readNfcCard) : super(ReaderNfcInitial()) {

    // зчитує картку
    on<StartNfcScan>((event, emit) async {
      // Спочатку перевіряємо доступність NFC
      final isAvailable = await NfcManager.instance.isAvailable();
      if (!isAvailable) {
        emit(ReaderNfcFailure("NFC вимкнено або не підтримується на цьому пристрої"));
        return;
      }

      emit(ReaderNfcScanning());
      try {
        final id = await readNfcCard();
        emit(ReaderNfcSuccess(id));
      } catch (e) {
        emit(ReaderNfcFailure(e.toString()));
      }
    });

    // трекає статус нфс
    on<CheckNfcStatus>((event, emit) async {
      final isAvailable = await NfcManager.instance.isAvailable();
      if (!isAvailable) {
        emit(ReaderNfcFailure("NFC вимкнено або не підтримується на цьому пристрої"));
        return;
      }

      // Якщо NFC доступний і ми не в стані сканування, починаємо новий скан
      if (state is! ReaderNfcScanning) {
        emit(ReaderNfcScanning());
        try {
          final id = await readNfcCard();
          emit(ReaderNfcSuccess(id));
        } catch (e) {
          emit(ReaderNfcFailure(e.toString()));
        }
      }
    });

    // зупиняє сканування
    on<StopNfcScan>((event, emit) async {
      try {
        await NfcManager.instance.stopSession();
        emit(ReaderNfcInitial());
      } catch (e) {
        emit(ReaderNfcFailure("Помилка зупинки сканування: $e"));
      }
    });

    // скидає стан до початкового
    on<ResetNfcState>((event, emit) {
      emit(ReaderNfcInitial());
    });
  }
}