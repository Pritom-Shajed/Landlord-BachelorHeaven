import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/intial/dashboard_controller.dart';
import 'package:bachelor_heaven_landlord/model/post_add_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class PostController extends GetxController {
  DashboardController _controller = Get.find();
  String category = 'Seat';
  File? addImage;
  User? _currentUser = FirebaseAuth.instance.currentUser;

  void pickCategory(String? value) {
    category = value!;
    update();
  }


  pickAddImage(ImageSource src) async {
    XFile? xfile = await ImagePicker().pickImage(source: src);
    if (xfile != null) {
      addImage = File(xfile.path);
      update();
    }
  }

  Future<void> pickCamOrGallery(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {
                  pickAddImage(ImageSource.camera);
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(Icons.camera_alt),
                    horizontalSpace,
                    Text('Camera'),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickAddImage(ImageSource.gallery);
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(Icons.photo),
                    horizontalSpace,
                    Text('Gallery'),
                  ],
                ),
              )
            ],
          );
        });
  }

  addPost(
      {required String adOwnerUid,
        required String latitude,
        required String longitude,
        required String adOwnerPhone,
        required String currentUserUid,
        required String title,
      required String category,
      required String location,
      required String price,
      required String description,
        required String time,
      required BuildContext context}) async {
    if (addImage != null) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
                child: CircularProgressIndicator(
              color: whiteColor,
            ));
          });
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('Ads-All')
          .child('landlord_$currentUserUid')
          .child(category)
          .child(time);

      TaskSnapshot task = await ref.putFile(addImage!);
      String downloadUrl = await task.ref.getDownloadURL();

      PostModel post = PostModel(
          adOwnerUid: adOwnerUid,
          adOwnerPhone: adOwnerPhone,
          latitude: latitude,
          longitude: longitude,
          uid: Uuid().v1(),
          title: title,
          location: location,
          price: price,
          category: category,
          description: description,
          pictureUrl: downloadUrl,
          postDate: currentDate);

      await FirebaseFirestore.instance
          .collection('Ads-Individual')
          .doc('landlord_$currentUserUid')
          .collection(category)
          .doc(time)
          .set(post.toJson())
          .then((value) => FirebaseFirestore.instance
              .collection('Ads-All')
              .doc(time)
              .set(post.toJson())
              .then(
                  (value) => Fluttertoast.showToast(msg: 'Successfully added!'))
              .then((value) => _controller.changeTabIndex(0))
              .then((value) => Get.offAllNamed('/dashboard')));
    } else {
      Fluttertoast.showToast(msg: 'Select at least one image');
    }
  }

  deletePost({required String uid, required String categoryName,required String currentUserUid,}) async {
    final CollectionReference ref =
        await FirebaseFirestore.instance.collection('Ads-All');

    QuerySnapshot snapshot = await ref.where('uid', isEqualTo: uid).get();

    snapshot.docs.forEach((element) {
      element.reference.delete();
    });

    deletePersonalPost(categoryName: categoryName, uid: uid, currentUserUid: currentUserUid);
  }

  deletePersonalPost(
      {required String categoryName, required String uid, required String currentUserUid,}) async {
    final CollectionReference ref = await FirebaseFirestore.instance
        .collection('Ads-Individual')
        .doc('landlord_$currentUserUid')
        .collection(categoryName);
    QuerySnapshot snapshot = await ref.where('uid', isEqualTo: uid).get();

    snapshot.docs.forEach((element) {
      element.reference.delete();
    });
  }
}
