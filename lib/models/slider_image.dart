
class SliderImage {
  String? id;
  final String imageUrl;
  final bool? active;

  SliderImage({
    this.id,
    required this.imageUrl,
    this.active,
  });

  factory SliderImage.fromJson(Map<String, dynamic> json, docId) {
    return SliderImage(
      active: json['active'],
      imageUrl:  json['imageUrl'],
    );
  }
}
