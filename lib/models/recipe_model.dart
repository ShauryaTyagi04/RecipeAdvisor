class Recipe {
  final int? id;
  final int? creatorId;
  final String name;
  final String description;
  final String category;
  final String cookTime;
  final num calories;
  final List<String> ingredients;
  final List<String> instructions;
  final String? source;

  Recipe({
    this.id,
    this.creatorId,
    required this.name,
    required this.description,
    required this.category,
    required this.cookTime,
    required this.calories,
    required this.ingredients,
    required this.instructions,
    this.source,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      creatorId: json['creator_id'],
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Uncategorized',
      cookTime: json['cook_time'] ?? 'N/A',
      calories: json['calories'] ?? 0,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      source: json['source'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'category': category,
        'cook_time': cookTime,
        'calories': calories,
        'ingredients': ingredients,
        'instructions': instructions,
      };
}
