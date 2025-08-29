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
  TextEditingController _precoGasolinaController = TextEditingController();
  TextEditingController _precoEtanolController = TextEditingController();
  
 
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
    _precoGasolinaController.text = '';
    _precoEtanolController.text = '';
    
 
    setState(() {
      _result = "";
    });
  }
 
  void calcularIMC() {
    double precoG = double.parse((_precoGasolinaController.text).replaceAll(',', '.'));
    double precoE = double.parse((_precoEtanolController.text).replaceAll(',', '.'));
    double distancia = 1550;
    double gasolina = 12;
    double etanol = 8;
    double resultN = 0;


    precoG = precoG * (distancia / gasolina);
    precoE = precoE * (distancia / etanol);

    {
      if (precoG > precoE) {
        _result = "Etanol";
        resultN = precoE;
      }
      else if (precoG < precoE) {
        _result = "Gasolina";   
        resultN = precoG;
      }
 
    setState(() {
    _result = ("O combustivel mais economico é ${(_result)} o valor total é ${(resultN.toStringAsFixed(2))}");
    });
  }
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
        child: Text('Calcule o preço do combustivel mais economico', style: TextStyle(color: Colors.red)),
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
      title: Text('Custo de viajem'),
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
              label: "Preço Gasolina: ",
              error: "Insira o Preço Gasolina",
              controller: _precoGasolinaController),
          buildTextFormField(
              label: "Preço Etanol: ",
              error: "Insira o Preço Etanol",
              controller: _precoEtanolController),
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