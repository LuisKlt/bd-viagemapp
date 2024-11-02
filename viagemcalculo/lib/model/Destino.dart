class Destino {
  int? id;
  String nome;
  int distancia;

  Destino({
    this.id,
    required this.nome,
    required this.distancia,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'distancia': distancia,
    };
  }

  factory Destino.fromMap(Map<String, dynamic> map) {
    return Destino(
      id: map['id'],
      nome: map['nome'],
      distancia: map['distancia'],
    );
  }
}
