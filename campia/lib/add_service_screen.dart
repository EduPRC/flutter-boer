import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class AddServiceScreen extends StatefulWidget {
  final String? serviceId; // se for edição, contém o ID
  final Map<String, dynamic>? existingData; // dados existentes para edição

  const AddServiceScreen({super.key, this.serviceId, this.existingData});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController verseController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final CollectionReference services =
      FirebaseFirestore.instance.collection('poems');

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      nameController.text = widget.existingData!['name'] ?? '';
      descriptionController.text = widget.existingData!['description'] ?? '';
      verseController.text = widget.existingData!['verse'] ?? '';
      dateController.text = widget.existingData!['date'] ?? '';
    }
  }

  Future<void> _saveService() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.serviceId == null) {
          // Adicionar novo Poema
          await services.add({
            'name': nameController.text,
            'description': descriptionController.text,
            'verse': verseController.text,
            'date': dateController.text,
          });
        } else {
          // Editar Poema existente
          await services.doc(widget.serviceId).update({
            'name': nameController.text,
            'description': descriptionController.text,
            'verse': verseController.text,
            'date': dateController.text,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.serviceId == null
                  ? 'Poema adicionado com sucesso!'
                  : 'Poema atualizado com sucesso!',
            ),
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar Poema: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    verseController.dispose();
    dateController.dispose();
    super.dispose();
  }

  // Função para abrir o DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.serviceId == null ? 'Adicionar Poema' : 'Editar Poema',
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nome do Poema
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Poema',
                  prefixIcon: Icon(Icons.build),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),

              // Descrição
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),

              // Preço
              TextFormField(
                controller: verseController,
                decoration: const InputDecoration(
                  labelText: 'Quantidate de Versos',
                  prefixIcon: Icon(Icons.format_list_numbered_rtl),
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+$')),
                ],
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),

              // Data de Cadastro
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Data de Criação',
                  prefixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                  hintText: 'dd/mm/aaaa',
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 32),

              // Botão de salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Poema'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: _saveService,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
