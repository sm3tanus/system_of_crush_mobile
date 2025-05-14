class Application {
  final int id;
  final String address;
  final String accident;
  final String importance;
  final String accidentCharacter;
  final String material;
  final String typeDamage;
  final String description;

  Application(
      {required this.id,
      required this.address,
      required this.accident,
      required this.importance,
      required this.accidentCharacter,
      required this.material,
      required this.typeDamage,
      required this.description,});

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] ?? 'Нет данных',
      address: json['address'] ?? 'Нет данных',
      accident: json['accident'] ?? 'Нет данных',
      importance: json['importance']?? 'Нет данных',
      accidentCharacter: json['accident'] ?? 'Нет данных',
      material: json['material'] ?? 'Нет данных',
      typeDamage: json['damage_type']?? 'Нет данных',
      description: json['description'] ?? 'Нет данных',
    );
  }
}
