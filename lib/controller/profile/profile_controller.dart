import 'package:bachelor_heaven_landlord/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {

  final _firestore = FirebaseFirestore.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;

  updateUserDetails(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(_currentUser!.uid)
        .update(user.toJson())
        .then((value) => Get.back())
        .then((value) => Get.back())
        .then((value) => Fluttertoast.showToast(msg: 'Successfully updated'));
  }



}
