class MealCategory {
  int id;
  String name;
  String imageUrl;

  MealCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
    };
  }
}
