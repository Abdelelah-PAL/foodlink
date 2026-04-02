class Meal {
  String? documentId;
  int? categoryId;
  String name;
  String? imageUrl;
  List<String> ingredients;
  List<String>? recipe;
  String? userId;
  bool? isFavorite;
  DateTime? date;
  String? day;
  String? source;
  int typeId;

  Meal({
    this.documentId,
    this.categoryId,
    required this.name,
    this.imageUrl,
    required this.ingredients,
    this.recipe,
    this.userId,
    this.isFavorite = false,
    this.date,
    this.day,
    this.source,
    required this.typeId
  });

  factory Meal.fromJson(Map<String, dynamic> json, dynamic docId) {
    return Meal(
      documentId: docId?.toString(),
      categoryId: json['category_id'] as int?,
      name: json['name'] ?? 'Unknown Meal',
      imageUrl: json['image_url'] as String?,
      ingredients: json['ingredients'] != null 
          ? List<String>.from(json['ingredients'] as Iterable) 
          : [],
      recipe: json['recipe'] != null 
          ? List<String>.from(json['recipe'] as Iterable) 
          : [],
      userId: json['user_id'] as String?,
      isFavorite: json['is_favorite'] as bool? ?? false,
      date: _parseDate(json['date']),
      day: json['day'] as String?,
      source: json['source'] as String?,
      typeId: json['type_id'] as int? ?? 1,
    );
  }

  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) return DateTime.tryParse(date);
    // Handle Firestore Timestamp if the method exists on the object
    try {
      return (date as dynamic).toDate();
    } catch (_) {
      return null;
    }
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
      'date': date,
      'day': day,
      'source': source,
      'type_id': typeId
    };
  }
}
