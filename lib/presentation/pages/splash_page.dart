import 'package:flutter/material.dart';
import '../../core/constants/app_gradients.dart';
import '../widgets/logo_fade_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/reader-selection');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppGradients.backgroundGradient,
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: LogoFadeWidget(),
        ),
      ),
    );
  }
}
