import 'package:flutter/material.dart';
import 'package:viagemcalculo/model/Destino.dart';
import 'package:viagemcalculo/model/destinoDAO.dart';

class DestinoTela extends StatefulWidget {
  const DestinoTela({super.key});

  @override
  State<DestinoTela> createState() => _DestinoTelaState();
}

class _DestinoTelaState extends State<DestinoTela> {
  final DestinoDAO _destinoDAO = DestinoDAO();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _cartaoController = TextEditingController();

  List<Destino> _listaDestinos = [];
  Destino? _destinoAtual;

  void _salvarOuEditar() async {
    if (_destinoAtual == null) {
      await _destinoDAO.insertDestino(Destino(
        nome: _nomeController.text,
        distancia: int.parse(_distanciaController.text),
      ));
    } else {
      _destinoAtual!.nome = _nomeController.text;
      _destinoAtual!.distancia = int.parse(_distanciaController.text);
      await _destinoDAO.updateDestino(_destinoAtual!);
    }
    _nomeController.clear();
    _distanciaController.clear();
    _cartaoController.clear();
    setState(() {
      _destinoAtual = null;
    });
    _loadDestinos();
  }

  @override
  void initState() {
    super.initState();
    _loadDestinos();
  }

  void _editarDestino(Destino destino) {
    setState(() {
      _destinoAtual = destino;
      _nomeController.text = destino.nome;
      _distanciaController.text = destino.distancia.toString();
    });
  }

  void _deleteDestino(int index) async {
    await _destinoDAO.deleteDestino(index);
    _loadDestinos();
  }

  void _loadDestinos() async {
    List<Destino> listaTemp = await _destinoDAO.selectDestinos();
    setState(() {
      _listaDestinos = listaTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 10),
          const Text(
            "Cadastrar Destinos",
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
              controller: _distanciaController,
              decoration: const InputDecoration(labelText: 'Distancia'),
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
              child: Text(_destinoAtual == null ? 'Salvar' : 'Atualizar'),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _listaDestinos.length,
              itemBuilder: (context, index) {
                final Destino destino = _listaDestinos[index];
                return Card(
                  child: ListTile(
                    title: Text(
                        'Id: ${destino.id} - Nome: ${destino.nome}\nDistância: ${destino.distancia}'),
                    trailing: IconButton(
                      onPressed: () {
                        _deleteDestino(destino.id!);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    onTap: () {
                      _editarDestino(destino);
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
