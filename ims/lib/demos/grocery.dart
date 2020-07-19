class Items {
  final String englishName, marathiName, hindiName;
  final int quantity;
  final double unit, price;

  Items(
      {this.englishName,
      this.marathiName,
      this.hindiName,
      this.quantity,
      this.unit,
      this.price});

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      englishName: json['englishName'] as String,
      marathiName: json['marathiName'] as String,
      hindiName: json['hindiName'] as String,
      quantity: json['quantity'] as int,
      unit: json['unit'] as double,
      price: json['price'] as double,
    );
  }
}
