import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/read_nfc_card.dart';
import 'reader_nfc_event.dart';
import 'reader_nfc_state.dart';

class ReaderNfcBloc extends Bloc<ReaderNfcEvent, ReaderNfcState> {
  final ReadNfcCard readNfcCard;

  ReaderNfcBloc(this.readNfcCard) : super(ReaderNfcInitial()) {
    on<StartNfcScan>((event, emit) async {
      emit(ReaderNfcScanning());
      try {
        final id = await readNfcCard();
        emit(ReaderNfcSuccess(id));
      } catch (e) {
        emit(ReaderNfcFailure(e.toString()));
      }
    });
  }
}
