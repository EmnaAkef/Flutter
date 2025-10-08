class Client {
  final String id;
  final String name;
  final DateTime createdAt;

  Client({required this.id, required this.name, required this.createdAt});

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
