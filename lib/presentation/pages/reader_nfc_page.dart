import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../domain/entities/card_reader.dart';
import '../bloc/reader_nfc/reader_nfc_bloc.dart';
import '../bloc/reader_nfc/reader_nfc_event.dart';
import '../bloc/reader_nfc/reader_nfc_state.dart';
import '../../../di/injection.dart';

class ReaderNfcPage extends StatelessWidget {
  final CardReader reader;

  const ReaderNfcPage({super.key, required this.reader});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReaderNfcBloc>()..add(StartNfcScan()),
      child: ReaderNfcView(reader: reader),
    );
  }
}

class ReaderNfcView extends StatefulWidget {
  final CardReader reader;

  const ReaderNfcView({super.key, required this.reader});

  @override
  State<ReaderNfcView> createState() => _ReaderNfcViewState();
}

class _ReaderNfcViewState extends State<ReaderNfcView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Коли користувач повертається до додатку
    if (state == AppLifecycleState.resumed) {
      // Через невелику затримку перевіряємо NFC
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.read<ReaderNfcBloc>().add(CheckNfcStatus());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text("InGo", style: AppTextStyles.logoStyle),
                    const SizedBox(width: 48), // щоб збалансувати простір справа
                  ],
                ),

                const Spacer(flex: 2),

                Container(
                  width: double.infinity,
                  height: 280,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accent.withOpacity(0.6),
                        AppColors.accent.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: AppColors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.reader.roomName,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 32,
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 60,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // NFC state
                BlocBuilder<ReaderNfcBloc, ReaderNfcState>(
                  builder: (context, state) {
                    if (state is ReaderNfcScanning) {
                      return _buildNfcStatus(
                        icon: Icons.nfc,
                        text: "Піднесіть NFC картку до пристрою...",
                      );
                    } else if (state is ReaderNfcSuccess) {
                      return _buildNfcStatus(
                        icon: Icons.check_circle_outline,
                        text: "Картку зчитано: ${state.cardId}",
                      );
                    } else if (state is ReaderNfcFailure) {
                      final isNfcDisabled = state.message.toLowerCase().contains("nfc");
                      return _buildNfcStatus(
                        icon: isNfcDisabled ? Icons.block : Icons.error_outline,
                        text: isNfcDisabled
                            ? "Увімкніть NFC в налаштуваннях\nПовернення до додатку автоматично перевірить стан"
                            : "Помилка: ${state.message}",
                      );
                    }

                    return _buildNfcStatus(
                      icon: Icons.nfc,
                      text: "Готово до сканування",
                    );
                  },
                ),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNfcStatus({required IconData icon, required String text}) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.white.withOpacity(0.9),
          size: 36,
        ),
        const SizedBox(height: 12),
        Text(
          text,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 18,
            color: AppColors.white,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}