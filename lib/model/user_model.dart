import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? email;
  String? profilePic;
  String? uid;
  String? location;
  String? joinedDate;
  String? phoneNumber;

  UserModel({
    required this.name,
    required this.email,
    required this.profilePic,
    required this.uid,
    required this.location,
    required this.joinedDate,
     this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'uid': uid,
      'location': location,
      'joinedDate': joinedDate,
      'phoneNumber': phoneNumber
    };
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;
    return UserModel(
      name: data['name'],
      email: data['email'],
      uid: data['uid'],
      profilePic: data['profilePic'],
      location: data['location'],
      joinedDate: data['joinedDate'],
      phoneNumber: data['phoneNumber'],
    );
  }
}
