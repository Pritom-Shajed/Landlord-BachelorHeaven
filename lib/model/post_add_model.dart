class PostModel {
  String? uid;
  String? title;
  String? location;
  String? price;
  String? category;
  String? description;
  String? pictureUrl;
  String? postDate;

  PostModel({
    required this.uid,
    required this.title,
    required this.location,
    required this.price,
    required this.category,
    required this.description,
    required this.pictureUrl,
    required this.postDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'location': location,
      'price': price,
      'category': category,
      'description': description,
      'pictureUrl': pictureUrl,
      'postDate': postDate,
    };
  }
}
