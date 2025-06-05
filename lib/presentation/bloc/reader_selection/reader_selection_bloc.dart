import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/card_reader.dart';
import '../../../domain/usecases/get_all_card_readers.dart';
import 'reader_selection_event.dart';
import 'reader_selection_state.dart';

class ReaderSelectionBloc extends Bloc<ReaderSelectionEvent, ReaderSelectionState> {
  final GetAllCardReaders getAllCardReaders;

  ReaderSelectionBloc(this.getAllCardReaders) : super(ReaderSelectionInitial()) {
    on<LoadCardReaders>((event, emit) async {
      emit(ReaderSelectionLoading());
      try {
        final readers = await getAllCardReaders();
        emit(ReaderSelectionLoaded(readers));
      } catch (e) {
        emit(ReaderSelectionError(e.toString()));
      }
    });
  }
}
