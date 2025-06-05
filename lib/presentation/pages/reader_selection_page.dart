import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_gradients.dart';
import '../../core/constants/app_text_styles.dart';
import '../bloc/reader_selection/reader_selection_bloc.dart';
import '../bloc/reader_selection/reader_selection_event.dart';
import '../bloc/reader_selection/reader_selection_state.dart';

class ReaderSelectionPage extends StatelessWidget {
  const ReaderSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text("InGo", style: AppTextStyles.logoStyle),
                const SizedBox(height: 20),
                const Text(
                  "Choose card reader",
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 22,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: BlocBuilder<ReaderSelectionBloc, ReaderSelectionState>(
                    builder: (context, state) {
                      if (state is ReaderSelectionLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ReaderSelectionLoaded) {
                        final readers = state.readers;
                        return GridView.builder(
                          itemCount: readers.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.2,
                          ),
                          itemBuilder: (context, index) {
                            final reader = readers[index];
                            return GestureDetector(
                              onTap: () {
                                // TODO: перехід до NFC-екрану
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.accent.withOpacity(0.5),
                                      AppColors.accent.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(color: AppColors.white.withOpacity(0.3)),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  reader.roomName,
                                  style: const TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    fontSize: 16,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is ReaderSelectionError) {
                        return Center(child: Text("Error: ${state.message}"));
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
