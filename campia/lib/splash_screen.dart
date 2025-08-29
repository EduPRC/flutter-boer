import 'dart:async';
import 'package:flutter/material.dart';
import 'home.dart';
 
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
 
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
 
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
 
  @override
  void initState() {
    super.initState();
 
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
 
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
 
    _controller.forward();
 
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SizedBox.expand( // garante que ocupa toda a tela
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem de fundo ocupando toda a tela
          Image.asset(
            "images/splashScreenCampia.png",
            fit: BoxFit.cover, // preenche a tela
          ),

          // Conteúdo central por cima da imagem
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 40),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }
}
