import 'package:flutter/material.dart';
import 'package:viagemcalculo/model/Combustivel.dart';
import 'package:viagemcalculo/model/CombustivelDAO.dart';

class CombustivelTela extends StatefulWidget {
  const CombustivelTela({super.key});

  @override
  State<CombustivelTela> createState() => _CombustivelTelaState();
}

class _CombustivelTelaState extends State<CombustivelTela> {
  final CombustivelDAO _combustivelDAO = CombustivelDAO();

  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  DateTime? selectedDate;

  List<Combustivel> _listaCombustiveis = [];
  Combustivel? _combustivelAtual;

  void _salvarOuEditar() async {
    if (_combustivelAtual == null) {
      await _combustivelDAO.insertCombustivel(Combustivel(
        preco: double.parse(_precoController.text),
        tipo: _tipoController.text,
        data: _dataController.text,
      ));
    } else {
      _combustivelAtual!.preco = double.parse(_precoController.text);
      _combustivelAtual!.tipo = _tipoController.text;
      _combustivelAtual!.data = _dataController.text;
      await _combustivelDAO.updateCombustivel(_combustivelAtual!);
    }
    _precoController.clear();
    _tipoController.clear();
    _dataController.clear();
    setState(() {
      _combustivelAtual = null;
    });
    _loadCombustiveis();
  }

  @override
  void initState() {
    super.initState();
    _loadCombustiveis();
  }

  void _editarCombustivel(Combustivel combustivel) {
    setState(() {
      _combustivelAtual = combustivel;
      _precoController.text = combustivel.preco.toString();
      _tipoController.text = combustivel.tipo;
      _dataController.text = combustivel.data;
    });
  }

  void _deleteCombustivel(int index) async {
    await _combustivelDAO.deleteCombustivel(index);
    _loadCombustiveis();
  }

  void _loadCombustiveis() async {
    List<Combustivel> listaTemp = await _combustivelDAO.selectCombustiveis();
    setState(() {
      _listaCombustiveis = listaTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 10),
          const Text(
            "Cadastrar Combustiveis",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _precoController,
              decoration: const InputDecoration(labelText: 'Preço'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _tipoController,
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _dataController,
              readOnly: true,
              decoration: const InputDecoration(
                label: Text("Data"),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2064),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                    _dataController.text =
                        "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
                  });
                }
              },
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
              child: Text(_combustivelAtual == null ? 'Salvar' : 'Atualizar'),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _listaCombustiveis.length,
              itemBuilder: (context, index) {
                final Combustivel combustivel = _listaCombustiveis[index];
                return Card(
                  child: ListTile(
                    title: Text(
                        'Id: ${combustivel.id} - Preço: ${combustivel.preco}\nTipo: ${combustivel.tipo}\nData: ${combustivel.data}'),
                    trailing: IconButton(
                      onPressed: () {
                        _deleteCombustivel(combustivel.id!);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    onTap: () {
                      _editarCombustivel(combustivel);
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
