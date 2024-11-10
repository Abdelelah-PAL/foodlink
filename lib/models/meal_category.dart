class MealCategory {
  int id;
  String name;
  String imageUrl;
  String mealsName;

  MealCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.mealsName
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      mealsName: json['meals_name'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'meals_name': mealsName
    };
  }
}
