class Recipe {
  final String name;
  final String description;
  final String category;
  final String cookTime;
  final num calories;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.name,
    required this.description,
    required this.category,
    required this.cookTime,
    required this.calories,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'] ?? 'No Name Provided',
      description: json['description'] ?? 'No Description Provided',
      category: json['category'] ?? 'N/A',
      cookTime: json['cook_time'] ?? 'N/A',
      calories: json['calories'] ?? 0,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
    );
  }
}
