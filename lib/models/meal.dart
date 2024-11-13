class Meal {
  String? documentId;
  int categoryId;
  String name;
  String? imageUrl;
  String ingredients;
  String? recipe;
  String userId;
  bool isFavorite;

  Meal(
      {this.documentId,
      required this.categoryId,
      required this.name,
      this.imageUrl,
      required this.ingredients,
      this.recipe,
      required this.userId,
      this.isFavorite = false});

  factory Meal.fromJson(Map<String, dynamic> json, docId) {
    return Meal(
        documentId: docId,
        categoryId: json['category_id'],
        name: json['name'],
        imageUrl: json['image_url'],
        ingredients: json['ingredients'],
        recipe: json['recipe'],
        userId: json['user_id'],
        isFavorite: json['is_favorite']);
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'name': name,
      'image_url': imageUrl,
      'ingredients': ingredients,
      'recipe': recipe,
      'user_id': userId,
      'is_favorite': isFavorite
    };
  }
}
