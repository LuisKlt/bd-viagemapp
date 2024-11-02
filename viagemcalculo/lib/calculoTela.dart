import 'package:viagemcalculo/calculoDAO.dart';
import 'package:viagemcalculo/model/Carro.dart';
import 'package:viagemcalculo/model/CarroDAO.dart';
import 'package:viagemcalculo/model/Combustivel.dart';
import 'package:viagemcalculo/model/CombustivelDAO.dart';
import 'package:viagemcalculo/model/Destino.dart';
import 'package:flutter/material.dart';
import 'package:viagemcalculo/model/destinoDAO.dart';

class CalculoTela extends StatefulWidget {
  const CalculoTela({super.key});

  @override
  State<CalculoTela> createState() => _CalculoTelaState();
}

class _CalculoTelaState extends State<CalculoTela> {
  List<Carro> carros = [];
  List<Destino> destinos = [];
  List<Combustivel> combustiveis = [];
  Carro? carroSelecionado;
  Destino? destinoSelecionado;
  Combustivel? combustivelSelecionado;

  final CarroDAO carroDAO = CarroDAO();
  final DestinoDAO destinoDAO = DestinoDAO();
  final CombustivelDAO combustivelDAO = CombustivelDAO();

  double? custoViagem;

  @override
  void initState() {
    super.initState();
    carregarDados();
    carregarCalculos();
  }

  Future<void> carregarDados() async {
    List<Carro> listaCarros = await carroDAO.selectCarros();
    List<Destino> listaDestinos = await destinoDAO.selectDestinos();
    List<Combustivel> listaCombustiveis =
        await combustivelDAO.selectCombustiveis();
    setState(() {
      carros = listaCarros;
      destinos = listaDestinos;
      combustiveis = listaCombustiveis;
    });
  }

  void calcular() async {
    if (carroSelecionado != null &&
        destinoSelecionado != null &&
        combustivelSelecionado != null) {
      int distancia = destinoSelecionado!.distancia;
      double consumo = carroSelecionado!.autonomia;
      double precoCombustivel = combustivelSelecionado!.preco;

      setState(() {
        custoViagem = (distancia / consumo) * precoCombustivel;
      });

      if (custoViagem != null) {
        await CalculoDAO().insertCalculo(custoViagem!);
        await carregarCalculos();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Custo registrado com sucesso!')),
        );
      }
    }
  }

  List<double> listaCalculos = [];

  Future<void> carregarCalculos() async {
    listaCalculos = await CalculoDAO().getCalculos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Calcular Custo",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: 360,
              child: DropdownButton<Carro>(
                value: carroSelecionado,
                hint: const Text('Selecione um carro'),
                isExpanded: true,
                items: carros.map((carro) {
                  return DropdownMenuItem<Carro>(
                    value: carro,
                    child: Text(carro.nome),
                  );
                }).toList(),
                onChanged: (Carro? novoCarro) {
                  setState(() {
                    carroSelecionado = novoCarro;
                  });
                },
              ),
            ),
            SizedBox(
              width: 360,
              child: DropdownButton<Destino>(
                value: destinoSelecionado,
                hint: const Text('Selecione um destino'),
                isExpanded: true,
                items: destinos.map((destino) {
                  return DropdownMenuItem<Destino>(
                    value: destino,
                    child: Text(destino.nome),
                  );
                }).toList(),
                onChanged: (Destino? novoDestino) {
                  setState(() {
                    destinoSelecionado = novoDestino;
                  });
                },
              ),
            ),
            SizedBox(
              width: 360,
              child: DropdownButton<Combustivel>(
                value: combustivelSelecionado,
                hint: const Text('Selecione um combustível'),
                isExpanded: true,
                items: combustiveis.map((combustivel) {
                  return DropdownMenuItem<Combustivel>(
                    value: combustivel,
                    child: Text(combustivel.tipo),
                  );
                }).toList(),
                onChanged: (Combustivel? novoCombustivel) {
                  setState(() {
                    combustivelSelecionado = novoCombustivel;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: calcular,
                style: const ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Color.fromARGB(255, 0, 91, 136)),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                child: const Text('Calcular'),
              ),
            ),
            const SizedBox(height: 10),
            if (custoViagem != null)
              Text(
                'Custo da viagem: R\$ ${custoViagem!.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: listaCalculos.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Center(
                        child: Text(
                            'Custo: R\$ ${listaCalculos[index].toStringAsFixed(2)}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
