class Meal {
  String? documentId;
  int? categoryId;
  String name;
  String? imageUrl;
  List<String> ingredients;
  String? recipe;
  String? userId;
  bool? isFavorite;
  bool isPlanned;
  DateTime? date;
  String? day;

  Meal({
    this.documentId,
    this.categoryId,
    required this.name,
    this.imageUrl,
    required this.ingredients,
    this.recipe,
    this.userId,
    this.isFavorite = false,
    required this.isPlanned,
    this.date,
    this.day,
  });

  factory Meal.fromJson(Map<String, dynamic> json, docId) {
    return Meal(
      documentId: docId,
      categoryId: json['category_id'],
      name: json['name'],
      imageUrl: json['image_url'],
      ingredients: List<String>.from(json['ingredients']),
      recipe: json['recipe'],
      userId: json['user_id'],
      isFavorite: json['is_favorite'],
      isPlanned: json['is_planned'],
      date: json['date']?.toDate(),
      day: json['day'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'name': name,
      'image_url': imageUrl,
      'ingredients': ingredients,
      'recipe': recipe,
      'user_id': userId,
      'is_favorite': isFavorite,
      'is_planned':isPlanned,
      'date': date,
      'day': day,
    };
  }
}
