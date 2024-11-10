class Meal {
  int categoryId;
  String name;
  String? imageUrl;
  String ingredients;
  String? recipe;
  String userId;

  Meal({
    required this.categoryId,
    required this.name,
    this.imageUrl,
    required this.ingredients,
    this.recipe,
    required this.userId
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      categoryId: json['category_id'],
      name: json['name'],
      imageUrl: json['image_url'],
      ingredients: json['ingredients'],
      recipe: json['recipe'],
      userId: 'user_id',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'category_id':categoryId,
      'name': name,
      'image_url': imageUrl,
      'ingredients': ingredients,
      'recipe': recipe,
      'user_id': userId
    };
  }
}
