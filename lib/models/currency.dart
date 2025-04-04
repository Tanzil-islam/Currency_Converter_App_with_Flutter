class Currency {
  final String code;
  final String name;
  
  Currency({required this.code, required this.name});
  
  factory Currency.fromJson(String code, String name) {
    return Currency(
      code: code,
      name: name,
    );
  }
  
  @override
  String toString() => '$code - $name';
}