import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/routes/app_router.dart';
import 'di/injection.dart';
import 'presentation/bloc/reader_selection/reader_selection_bloc.dart';
import 'presentation/bloc/reader_selection/reader_selection_event.dart';

class InGoApp extends StatelessWidget {
  const InGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ReaderSelectionBloc>()..add(LoadCardReaders()),
        ),
        // Тут блоки
      ],
      child: MaterialApp(
        title: 'InGo Card Reader',
        theme: ThemeData(fontFamily: 'Montserrat'),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
