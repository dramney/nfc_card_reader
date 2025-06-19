abstract class ReaderNfcEvent {}

class StartNfcScan extends ReaderNfcEvent {}

class CheckNfcStatus extends ReaderNfcEvent {}

class StopNfcScan extends ReaderNfcEvent {}

class ResetNfcState extends ReaderNfcEvent {}