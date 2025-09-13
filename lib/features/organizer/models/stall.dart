class Stall {
  String name;
  String boothNumber;
  List<String> assets;

  Stall({required this.name, this.boothNumber = '', this.assets = const []});

  factory Stall.fromMap(Map<String, dynamic> map) {
    return Stall(
      name: map['name'] ?? '',
      boothNumber: map['booth_number'] ?? '',
      assets: List<String>.from(map['assets'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'booth_number': boothNumber, 'assets': assets};
  }
}
