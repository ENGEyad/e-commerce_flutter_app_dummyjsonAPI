// lib/models/recipe_models.dart
class Recipe {
  final int id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  final String mealType;
  final List<String> tags;
  final double rating;
  final int reviewCount;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.mealType,
    required this.tags,
    required this.rating,
    required this.reviewCount,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? const []),
      instructions: List<String>.from(json['instructions'] ?? const []),
      mealType: (json['mealType'] as List<dynamic>? ?? []).isNotEmpty
          ? json['mealType'][0].toString()
          : '',
      tags: List<String>.from(json['tags'] ?? const []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
    );
  }
}