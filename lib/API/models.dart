class Application {
  final int id;
  final String createDate;
  final String address;
  final String accident;
  final String importance;

  Application(
      {required this.id,
      required this.address,
      required this.accident,
      required this.importance,
      required this.createDate});

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'],
      address: json['address'],
      accident: json['accident']['name'],
      importance: json['importance']['name'],
      createDate: json['create_date']
    );
  }
}
