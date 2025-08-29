import 'package:flutter/material.dart';
import 'splash_screen.dart';
 
void main() {
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campia',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Colors.red,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.red,
          secondary: Colors.black,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}