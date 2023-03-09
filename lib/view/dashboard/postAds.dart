
import 'package:bachelor_heaven_landlord/controller/post/post_controller.dart';
import 'package:bachelor_heaven_landlord/controller/post/post_stepper_controller.dart';
import 'package:bachelor_heaven_landlord/widgets/post%20add/stepList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PostAds extends StatefulWidget {
  PostAds({Key? key}) : super(key: key);

  @override
  State<PostAds> createState() => _PostAdsState();
}

class _PostAdsState extends State<PostAds> {
  TextEditingController titleController = TextEditingController();

  TextEditingController locationController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  PostController _postController =Get.find();

  User? _currentUser = FirebaseAuth.instance.currentUser;

  String _currentTime =
  DateFormat.yMMMMd('en_US').add_jms().format(DateTime.now());

  List<Location>? locations;
  getLatLon(String input)async{
    locations =  await locationFromAddress(input);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StepperController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
            child: Obx(
                  () => Stepper(
                currentStep: controller.currentStep.value,
                type: StepperType.vertical,
                steps: stepList(
                    locationTitle: 'Hi',
                    titleController: titleController,
                    locationController: locationController,
                    priceController: priceController,
                    descriptionController: descriptionController,
                    context: context),
                onStepContinue: () async {
                  if (controller.currentStep.value == 0) {
                    if (titleController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Enter a title', toastLength: Toast.LENGTH_SHORT);
                    } else if (priceController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Enter the price', toastLength: Toast.LENGTH_SHORT);
                    } else if (locationController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Enter your location',
                          toastLength: Toast.LENGTH_SHORT);
                    } else {
                      getLatLon(locationController.text.toString());
                      controller.stepIncrement();
                    }
                  } else if (controller.currentStep == 1) {
                    if (descriptionController.text.isEmpty) {
                      Fluttertoast.showToast(msg: 'Enter the description');
                    } else {
                      controller.stepIncrement();
                    }
                  } else {
                    if (_postController.addImage == null) {
                      Fluttertoast.showToast(msg: 'Add a photo');
                    } else {
                      QuerySnapshot userData = await FirebaseFirestore.instance
                          .collection('landlords')
                          .where('uid', isEqualTo: _currentUser!.uid)
                          .get();
                      _postController.addPost(
                          context: context,
                          latitude: '${locations!.last.latitude}',
                          longitude: '${locations!.last.longitude}',
                          currentUserUid: _currentUser!.uid,
                          adOwnerUid: _currentUser!.uid,
                          adOwnerPhone: '${userData.docs.single['phoneNumber']}',
                          time: _currentTime,
                          title: titleController.text.trim(),
                          category: _postController.category,
                          description: descriptionController.text.trim(),
                          location: locationController.text.trim(),
                          price: priceController.text.trim());
                    }
                  }
                },
                onStepCancel: () {
                  if (controller.currentStep.value == 0) {
                    print('Completed');
                  } else {
                    controller.stepDecrement();
                  }
                },
              ),
            )),
      );
    });
  }
}

