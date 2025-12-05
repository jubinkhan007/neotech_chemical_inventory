/// Domain model for a chemical in the inventory.
class Chemical {
  const Chemical({
    required this.id,
    required this.productName,
    required this.casNumber,
    required this.manufacturer,
    required this.stockQuantity,
    required this.unit,
  });

  final String id;
  final String productName;
  final String casNumber;
  final String manufacturer;
  final double stockQuantity;
  final String unit;
}
