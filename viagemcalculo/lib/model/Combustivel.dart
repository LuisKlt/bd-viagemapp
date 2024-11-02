class Combustivel {
  int? id;
  double preco;
  String tipo;
  String data;

  Combustivel({
    this.id,
    required this.preco,
    required this.tipo,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'preco': preco,
      'tipo': tipo,
      'data': data,
    };
  }

  factory Combustivel.fromMap(Map<String, dynamic> map) {
    return Combustivel(
      id: map['id'],
      preco: map['preco'],
      tipo: map['tipo'],
      data: map['data'],
    );
  }
}
