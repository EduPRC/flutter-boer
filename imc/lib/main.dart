//pacote que contém os componentes do layout do formulário
import 'package:flutter/material.dart';
 
//método principal da classe
void main() => runApp(
      //MaterialApp->utiliza as partes gráficas
      //para elaboração dos layouts
      MaterialApp(
        //primeiramente executa a classe Home
        home: Home(),
        //utiliza um pequeno banner no aplicativo
        debugShowCheckedModeBanner: false,
      ),
    );
 
//início
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}
 
class HomeState extends State<Home> {
  //para poder utilizar as ações dos botões de acordo
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 
  //criando os campos de entrada de dados
  TextEditingController _pesoController = TextEditingController();
  TextEditingController _alturaController = TextEditingController();
  
 
  //contém valor do resultado final
  String _result = "";
 
  //método para zerar todos os campos quando o aplicativo
  //for aberto
  @override
  void initState() {
    //iniciando o estado do aplicativo ao ser executado
    super.initState();
    //chamando o método para limpar os dados informados
    limpaCampos();
  }
 
  void limpaCampos() {
    _pesoController.text = '';
    _alturaController.text = '';
    
 
    setState(() {
      _result = '';
    });
  }
 
  void calcularIMC() {
    double _kg = double.parse((_pesoController.text).replaceAll(',', '.'));
    double _m = double.parse((_alturaController.text).replaceAll(',', '.'));
    double _imc = _kg / (_m * _m);
 
    {
      if (_imc < 18.5) {
        _result = "Abaixo do Peso";
      } else if (_imc >= 18.5 && _imc < 24.9) {
        _result = "Peso Normal";
      } else if (_imc >= 25 && _imc < 29.9) {
        _result = "Sobrepeso";
      } else if (_imc >= 30 && _imc < 34.9) {
        _result = "Obesidade Grau I";
      } else if (_imc >= 35 && _imc < 39.9) {
        _result = "Obesidade Grau II";
      } else {
        _result = "Obesidade Grau III";
      }
  }
 
    setState(() {
      _result = "Seu IMC é: ${_imc.toStringAsPrecision(3)}\n$_result";
    });
  }
 
  //criando o botão para calcular o Valor a Pagar
  Widget buildCalcularButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            calcularIMC();
          }
        },
        child: Text('Calcule o IMC', style: TextStyle(color: Colors.red)),
      ),
    );
  }
 
  //método para configurar o resultado em uma Text
  Widget buildTextResult() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: Text(
        _result,
        textAlign: TextAlign.center,
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Colors.orange[100],
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0), child: buildForm()));
  }
 
  AppBar buildAppBar() {
    return AppBar(
      title: Text('Calcule o IMC'),
      backgroundColor: Colors.orange,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            limpaCampos();
          },
        )
      ],
    );
  }
 
  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTextFormField(
              label: "Peso (kg)",
              error: "Insira o peso em kg!",
              controller: _pesoController),
          buildTextFormField(
              label: "Altura (m)",
              error: "Insira a altura em metros!",
              controller: _alturaController),
          buildTextResult(),
          buildCalcularButton(),
        ],
      ),
    );
  }
 
  //formatar e exibir msg de erro nos inputs (entrada
  //de dados)
  TextFormField buildTextFormField(
      {required TextEditingController controller, required String error, required String label}) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        //verifica se o valor foi digitado
        return text!.isEmpty ? error : null;
      },
    );
  }
}