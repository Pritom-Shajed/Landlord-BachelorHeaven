import 'dart:io';
import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {

  File? image;
  RxBool obscureText = true.obs;



  pickImage(ImageSource src) async {
    XFile? xfile = await ImagePicker().pickImage(source: src);
    if (xfile != null) {
      image = File(xfile.path);
      update();
    }
  }

  changeObscureText(bool value){
    obscureText.value = value;
  }

  signUp({
    required BuildContext context,
    required String email,
    required String pass,
    required String name,
    required String location,
    required String phoneNumber,
  }) async {
    try {
      if (image != null) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(
                  color: whiteColor,
                ),
              );
            });

        //Sign in
        UserCredential credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );

        await credential.user!.updateDisplayName(name);

        //Upload Image
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('profile-pic')
            .child('user_${credential.user!.uid}');

        TaskSnapshot taskSnapshot = await ref.putFile(image!);

        String profilePicUrl = await taskSnapshot.ref.getDownloadURL();

        await credential.user!.updatePhotoURL(profilePicUrl);

        //Storing informations
        UserModel user = UserModel(
          name: name,
          email: email,
          uid: credential.user!.uid,
          profilePic: profilePicUrl,
          location: location,
          joinedDate: currentDate,
          phoneNumber: phoneNumber,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson())
            .then((value) => Get.snackbar('Successfully Registered',
                'Hi $name, Welcome to Bachelor Heaven.',
                duration: Duration(seconds: 3)))
            .then((value) => Get.offAllNamed('/dashboard'));
      } else {
        Fluttertoast.showToast(msg: 'Please select your profile picture');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'The account already exists for $email.');
      }
    } catch (e) {
      Get.snackbar('Error Occured', 'Please try again',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2));
      print(e);
    }
  }

  // signInWithGoogle(
  //     {required String location,
  //     required BuildContext context,
  //     required String phoneNumber}) async {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //         return Center(
  //           child: CircularProgressIndicator(
  //             color: whiteColor,
  //           ),
  //         );
  //       });
  //
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;
  //
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   // Once signed in, return the UserCredential
  //   UserCredential currrentUser =
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //   UserModel user = UserModel(
  //       name: currrentUser.user!.displayName,
  //       email: currrentUser.user!.email,
  //       uid: currrentUser.user!.uid,
  //       location: location,
  //       profilePic: currrentUser.user!.photoURL,
  //       joinedDate: currentDate,
  //       phoneNumber: phoneNumber);
  //
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currrentUser.user!.uid)
  //       .set(user.toJson())
  //       .then((value) => Get.snackbar(
  //           'Logged In', 'Welcome to Bachelor Heaven.',
  //           duration: Duration(seconds: 2)))
  //       .then((value) => Get.offAllNamed('/nav_panel'));
  // }

  singIn(
      {required String email,
      required String pass,
      required BuildContext context}) async {
    try {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(
                color: whiteColor,
              ),
            );
          });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass)
          .then((value) => Get.snackbar(
              'Logged In', 'Welcome to Bachelor Heaven.',
          snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2)))
          .then((value) => Get.offAllNamed('/dashboard'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'No user found for $email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Wrong password provided for $email.');
      }
    }
  }

  signOut(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: whiteColor,
            ),
          );
        });
    await FirebaseAuth.instance
        .signOut()
        .then((value) => Get.snackbar('Logged out', 'Hope to see you soon.',
        snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2)))
        .then((value) => Get.offAllNamed('/login'));
  }
}
