import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _isLoading = false;

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) return "Digite uma senha";
    if (value.length < 6) return "A senha deve ter pelo menos 6 caracteres";
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "A senha deve conter pelo menos 1 letra maiúscula";
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "A senha deve conter pelo menos 1 letra minúscula";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "A senha deve conter pelo menos 1 número";
    }
    if (!RegExp(r'[!@#\$&*~.,;:?]').hasMatch(value)) {
      return "A senha deve conter pelo menos 1 caractere especial";
    }
    return null;
  }

  Future<void> _fazerCadastro() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isLoading = true);

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _senhaController.text.trim(),
        );

        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'name': _nameController.text, // Nome informado no cadastro
            'email': _emailController.text,
          });
        }

        await userCredential.user!
            .updateDisplayName(_nameController.text.trim());

        // Mostra mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cadastro realizado com sucesso!")),
        );

        // Redireciona para tela de login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } on FirebaseAuthException catch (e) {
        String mensagemErro;
        if (e.code == 'email-already-in-use') {
          mensagemErro = "Este email já está em uso.";
        } else if (e.code == 'invalid-email') {
          mensagemErro = "Digite um email válido.";
        } else if (e.code == 'weak-password') {
          mensagemErro = "A senha é muito fraca.";
        } else {
          mensagemErro = "Erro ao cadastrar: ${e.message}";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensagemErro)),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nome"),
                  validator: (value) {
                    if (value == null || value.trim().length < 3) {
                      return "O nome deve ter pelo menos 3 caracteres";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Digite seu email";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Digite um email válido";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  decoration: const InputDecoration(labelText: "Senha"),
                  obscureText: true,
                  validator: _validarSenha,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _fazerCadastro,
                        child: const Text("Cadastrar"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
