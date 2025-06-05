abstract class ReaderNfcState {}

class ReaderNfcInitial extends ReaderNfcState {}

class ReaderNfcScanning extends ReaderNfcState {}

class ReaderNfcSuccess extends ReaderNfcState {
  final String cardId;

  ReaderNfcSuccess(this.cardId);
}

class ReaderNfcFailure extends ReaderNfcState {
  final String message;

  ReaderNfcFailure(this.message);
}
