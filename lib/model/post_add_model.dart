class PostModel {
  String? adOwnerUid;
  String? adOwnerPhone;
  String? uid;
  String? title;
  String? address;
  String? division;
  String? price;
  String? category;
  String? description;
  String? pictureUrl;
  String? postDate;
  String? latitude;
  String? longitude;

  PostModel({
    required this.adOwnerUid,
    required this.adOwnerPhone,
    required this.uid,
    required this.title,
    required this.address,
    required this.division,
    required this.price,
    required this.category,
    required this.description,
    required this.pictureUrl,
    required this.postDate,
    required this.latitude,
    required this.longitude,

  });

  Map<String, dynamic> toJson() {
    return {
      'adOwnerUid': adOwnerUid,
      'adOwnerPhone':adOwnerPhone,
      'uid': uid,
      'title': title,
      'location': address,
      'division': division,
      'price': price,
      'category': category,
      'description': description,
      'pictureUrl': pictureUrl,
      'postDate': postDate,
      'latitude': latitude,
      'longitude': longitude
    };
  }
}
