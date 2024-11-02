import 'package:flutter/material.dart';
import 'package:viagemcalculo/model/Carro.dart';
import 'package:viagemcalculo/model/CarroDAO.dart';

class CarroTela extends StatefulWidget {
  const CarroTela({super.key});

  @override
  State<CarroTela> createState() => _CarroTelaState();
}

class _CarroTelaState extends State<CarroTela> {
  final CarroDAO _carroDAO = CarroDAO();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _autonomiaController = TextEditingController();

  List<Carro> listaCarros = [];
  Carro? _carroAtual;

  void _salvarOuEditar() async {
    if (_carroAtual == null) {
      await _carroDAO.insertCarro(Carro(
        nome: _nomeController.text,
        autonomia: double.parse(_autonomiaController.text),
      ));
    } else {
      _carroAtual!.nome = _nomeController.text;
      _carroAtual!.autonomia = double.parse(_autonomiaController.text);
      await _carroDAO.updateCarro(_carroAtual!);
    }
    _nomeController.clear();
    _autonomiaController.clear();
    setState(() {
      _carroAtual = null;
    });
    _loadCarros();
  }

  @override
  void initState() {
    super.initState();
    _loadCarros();
  }

  void _editarCarro(Carro carro) {
    setState(() {
      _carroAtual = carro;
      _nomeController.text = carro.nome;
      _autonomiaController.text = carro.autonomia.toString();
    });
  }

  void _deleteCarro(int index) async {
    await _carroDAO.deleteCarro(index);
    _loadCarros();
  }

  void _loadCarros() async {
    List<Carro> listaTemp = await _carroDAO.selectCarros();
    setState(() {
      listaCarros = listaTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Cadastrar Carros",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _autonomiaController,
              decoration: const InputDecoration(labelText: 'Autonomia'),
            ),
          ),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(Color.fromARGB(255, 0, 91, 136)),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              onPressed: _salvarOuEditar,
              child: Text(_carroAtual == null ? 'Salvar' : 'Atualizar'),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: listaCarros.length,
              itemBuilder: (context, index) {
                final Carro carro = listaCarros[index];
                return Card(
                  child: ListTile(
                    title: Text(
                        'Id: ${carro.id} - Nome: ${carro.nome}\nAutonomia: ${carro.autonomia}'),
                    trailing: IconButton(
                      onPressed: () {
                        _deleteCarro(carro.id!);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    onTap: () {
                      _editarCarro(carro);
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
