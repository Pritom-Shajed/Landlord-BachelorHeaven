import 'package:bachelor_heaven_landlord/constants/constants.dart';
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
  String category = 'Seat';
  RxString currentTime =
      DateFormat.yMMMMd('en_US').add_jms().format(DateTime.now()).obs;
  File? addImage;
  final _currentUser = FirebaseAuth.instance.currentUser;

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
      {required String title,
      required String category,
      required String location,
      required String price,
      required String description,
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
          .child('adds')
          .child('user_${_currentUser!.uid}')
          .child(category)
          .child('${currentTime.value}');

      TaskSnapshot task = await ref.putFile(addImage!);
      String downloadUrl = await task.ref.getDownloadURL();

      PostModel post = PostModel(
          uid: Uuid().v1(),
          title: title,
          location: location,
          price: price,
          category: category,
          description: description,
          pictureUrl: downloadUrl,
          postDate: currentDate);

      await FirebaseFirestore.instance
          .collection('individualAdds')
          .doc('user_${_currentUser!.uid}')
          .collection(category)
          .doc('${currentTime.value}')
          .set(post.toJson())
          .then((value) => FirebaseFirestore.instance
              .collection('allAdds')
              .doc('${currentTime.value}')
              .set(post.toJson())
              .then(
                  (value) => Fluttertoast.showToast(msg: 'Successfully added!'))
              .then((value) => Get.offAllNamed('/nav_panel')));
    } else {
      Fluttertoast.showToast(msg: 'Select at least one image');
    }
  }

  deletePost({required String uid, required String categoryName}) async {
    final CollectionReference ref =
        await FirebaseFirestore.instance.collection('allAdds');

    QuerySnapshot snapshot =
        await ref.where('uid', isEqualTo: uid).get();

    snapshot.docs.forEach((element) {
      element.reference.delete();
    });

    deletePersonalPost(categoryName: categoryName, uid: uid);
  }

  deletePersonalPost(
      {required String categoryName, required String uid}) async {
    final CollectionReference ref = await FirebaseFirestore.instance
        .collection('individualAdds')
        .doc('user_${_currentUser!.uid}')
        .collection(categoryName);
    QuerySnapshot snapshot = await ref.where('uid', isEqualTo: uid).get();

    snapshot.docs.forEach((element) {
      element.reference.delete();
    });
  }
}
