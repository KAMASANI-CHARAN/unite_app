class Ticket {
  String name;
  double price;
  int quantity;
  String currency;

  Ticket({
    required this.name,
    this.price = 0.0,
    this.quantity = 0,
    this.currency = 'USD',
  });

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      name: map['name'] ?? 'Standard',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 0,
      currency: map['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'currency': currency,
    };
  }
}
