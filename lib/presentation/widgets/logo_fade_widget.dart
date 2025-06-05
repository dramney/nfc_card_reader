import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';

class LogoFadeWidget extends StatefulWidget {
  const LogoFadeWidget({super.key});

  @override
  State<LogoFadeWidget> createState() => _LogoFadeWidgetState();
}

class _LogoFadeWidgetState extends State<LogoFadeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text('InGo', style: AppTextStyles.logoStyle),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
