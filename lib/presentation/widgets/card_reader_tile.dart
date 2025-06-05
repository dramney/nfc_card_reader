import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/card_reader.dart';

class CardReaderTile extends StatelessWidget {
  final CardReader reader;
  final VoidCallback onTap;

  const CardReaderTile({
    super.key,
    required this.reader,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
  }
}