class MealCategory {
  String name;
  String imageUrl;

  MealCategory({
    required this.name,
    required this.imageUrl,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image_url': imageUrl,
    };
  }
}
