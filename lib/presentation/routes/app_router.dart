import 'package:flutter/material.dart';
import '../pages/splash_page.dart';
import '../pages/reader_selection_page.dart';
import '../pages/reader_nfc_page.dart';
import '../../domain/entities/card_reader.dart';

class AppRouter {
  static const String splash = '/';
  static const String readerSelection = '/reader-selection';
  static const String readerNfc = '/reader';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case readerSelection:
        return MaterialPageRoute(builder: (_) => const ReaderSelectionPage());
      case readerNfc:
        final reader = settings.arguments as CardReader;
        return MaterialPageRoute(
          builder: (_) => ReaderNfcPage(reader: reader),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
