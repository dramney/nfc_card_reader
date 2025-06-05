import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../data/repositories/card_reader_repository_impl.dart';
import '../data/repositories/nfc_repository_impl.dart';
import '../domain/repositories/card_reader_repository.dart';
import '../domain/repositories/nfc_repository.dart';
import '../domain/usecases/get_all_card_readers.dart';
import '../domain/usecases/read_nfc_card.dart';
import '../presentation/bloc/reader_nfc/reader_nfc_bloc.dart';
import '../presentation/bloc/reader_selection/reader_selection_bloc.dart';


final sl = GetIt.instance;

void init() {

  // Firebase
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Repository
  sl.registerLazySingleton<CardReaderRepository>(() => CardReaderRepositoryImpl(sl()));
  sl.registerLazySingleton<NfcRepository>(() => NfcRepositoryImpl());

  // Usecase
  sl.registerLazySingleton(() => GetAllCardReaders(sl()));
  sl.registerLazySingleton(() => ReadNfcCard(sl()));

  // Bloc
  sl.registerFactory(() => ReaderSelectionBloc(sl()));
  sl.registerFactory(() => ReaderNfcBloc(sl()));
}
