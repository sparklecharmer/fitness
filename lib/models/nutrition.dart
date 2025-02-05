class Nutrition {
  final String name;
  final double totalFat;
  final double saturatedFat;
  final double sodium;
  final double potassium;
  final double cholesterol;
  final double totalCarbohydrates;
  final double fiber;
  final double sugar;

  Nutrition({
    required this.name,
    required this.totalFat,
    required this.saturatedFat,
    required this.sodium,
    required this.potassium,
    required this.cholesterol,
    required this.totalCarbohydrates,
    required this.fiber,
    required this.sugar,


  });


  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      name: json['name'],
      totalCarbohydrates: json['carbohydrates_total_g'].toDouble(),
      totalFat: json['fat_total_g'].toDouble(),
      saturatedFat: json['fat_saturated_g'].toDouble(),
      sodium: json['sodium_mg'].toDouble(),
      sugar: json['sugar_g'].toDouble(),
      cholesterol: json['cholesterol_mg'].toDouble(),
      fiber: json['fiber_g'].toDouble(),
      potassium: json['potassium_mg'].toDouble(),
    );
  }
}
