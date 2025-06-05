import '../../../domain/entities/card_reader.dart';

abstract class ReaderSelectionState {}

class ReaderSelectionInitial extends ReaderSelectionState {}

class ReaderSelectionLoading extends ReaderSelectionState {}

class ReaderSelectionLoaded extends ReaderSelectionState {
  final List<CardReader> readers;
  ReaderSelectionLoaded(this.readers);
}

class ReaderSelectionError extends ReaderSelectionState {
  final String message;
  ReaderSelectionError(this.message);
}
