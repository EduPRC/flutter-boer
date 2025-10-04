import 'package:flutter/material.dart';
import 'home.dart';
import 'service_list_screen.dart'; // Agora será a tela de Poemas
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'escrever_screen.dart';

class MenuUser extends StatefulWidget {
  const MenuUser({super.key});

  @override
  State<MenuUser> createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
  const HomeScreen(),       // Início
  ServiceListScreen(),      // Poemas
  const EscreverScreen(),   // Escrever
  const ProfileScreen(),    // Perfil
  const SettingsScreen(),   // Configurações
];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
          items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Poemas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Escrever',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
