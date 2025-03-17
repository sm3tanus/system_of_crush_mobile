class Application {
  final int id;
  final String createDate;
  final String address;
  final String accident;
  final String importance;
  final String accidentCharacter;
  final String material;
  final String typeDamage;
  final String description;
  final String status;

  Application(
      {required this.id,
      required this.address,
      required this.accident,
      required this.importance,
      required this.createDate,
      required this.accidentCharacter,
      required this.material,
      required this.typeDamage,
      required this.description,
      required this.status});

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] ?? '-',
      address: json['address'] ?? '-',
      accident: json['accident']['name'] ?? '-',
      importance: json['importance']['name'] ?? '-',
      createDate: json['create_date'] ?? '-',
      accidentCharacter: json['accident']['accident_character']['name'] ?? '-',
      material: json['material']['id'] == null ? '-' : json['material']['name'],
      typeDamage: json['damage_type']['id'] == null ? '-' : json['damage_type']['name'],
      description: json['description'] ?? '-',
      status:  json['status']['name'] ?? '-'
    );
  }
}
