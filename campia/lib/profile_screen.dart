import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // 🔹 Carrega os dados do usuário logado
  Future<void> _loadUserProfile() async {
    if (user != null) {
      emailController.text = user!.email ?? "";

      final doc = await users.doc(user!.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        nameController.text = data['name'] ?? '';
        genderController.text = data['gender'] ?? '';
        birthController.text = data['birthDate'] ?? '';
        imageUrlController.text = data['imageUrl'] ?? '';
        setState(() {});
      }
    }
  }

  // 🔹 Salva ou atualiza o perfil
  Future<void> _saveUserProfile() async {
    if (user == null) return;

    await users.doc(user!.uid).set({
      'name': nameController.text,
      'email': emailController.text,
      'gender': genderController.text,
      'birthDate': birthController.text,
      'imageUrl': imageUrlController.text,
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
  }

  // 🔹 Constrói o avatar com botão +
  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          backgroundImage: _getProfileImage(),
          child: _getProfileImage() == null
              ? const Icon(Icons.person, size: 60, color: Colors.white)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: InkWell(
            onTap: _showImageDialog,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, size: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Retorna a imagem válida (URL ou Base64) ou null
  ImageProvider? _getProfileImage() {
    final text = imageUrlController.text.trim();

    if (text.isEmpty) return null;

    // Tenta carregar como Base64
    try {
      if (text.startsWith("data:image") || text.length > 100) {
        final decodedBytes = base64Decode(text.split(',').last);
        return MemoryImage(decodedBytes);
      }
    } catch (_) {}

    // Tenta carregar como URL
    if (Uri.tryParse(text)?.isAbsolute ?? false) {
      return NetworkImage(text);
    }

    return null;
  }

  // 🔹 Dialog para adicionar/editar imagem
  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final tempController =
            TextEditingController(text: imageUrlController.text);
        return AlertDialog(
          title: const Text("Adicionar/Alterar Imagem"),
          content: TextField(
            controller: tempController,
            decoration: const InputDecoration(
              labelText: "Cole a URL ou Base64",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                final newValue = tempController.text.trim();
                if (_validateImage(newValue)) {
                  setState(() {
                    imageUrlController.text = newValue;
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            "Imagem inválida: insira uma URL ou Base64 válida.")),
                  );
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  // 🔹 Validação de imagem
  bool _validateImage(String value) {
    if (value.isEmpty) return false;

    // Base64 válido?
    try {
      if (value.startsWith("data:image") || value.length > 100) {
        base64Decode(value.split(',').last);
        return true;
      }
    } catch (_) {}

    // URL válida?
    if (Uri.tryParse(value)?.isAbsolute ?? false) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Perfil"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🔹 Foto de perfil com botão +
              _buildProfileImage(),
              const SizedBox(height: 20),

              // 🔹 Nome
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 🔹 Email (somente leitura)
              TextFormField(
                controller: emailController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 🔹 Sexo
              TextFormField(
                controller: genderController,
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  prefixIcon: Icon(Icons.wc),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 🔹 Data de nascimento
              TextFormField(
                controller: birthController,
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento (dd/mm/aaaa)',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              // 🔹 Botão salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Salvar Perfil"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: _saveUserProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
