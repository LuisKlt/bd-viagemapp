class Carro {
  int? id;
  String nome;
  double autonomia;

  Carro({
    this.id,
    required this.nome,
    required this.autonomia,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'autonomia': autonomia,
    };
  }

  factory Carro.fromMap(Map<String, dynamic> map) {
    return Carro(
      id: map['id'],
      nome: map['nome'],
      autonomia: map['autonomia'],
    );
  }
}
