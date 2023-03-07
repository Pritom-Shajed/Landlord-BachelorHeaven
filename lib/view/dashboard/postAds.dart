import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/dashboard/post_controller.dart';
import 'package:bachelor_heaven_landlord/controller/intial/dashboard_controller.dart';
import 'package:bachelor_heaven_landlord/controller/profile/profile_controller.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_Button.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_textField.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PostAds extends StatelessWidget {
  PostAds({super.key});

  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _currentTime = DateFormat.yMMMMd('en_US').add_jms().format(DateTime.now());
  User? _currentUser = FirebaseAuth.instance.currentUser;


  final List<String> items = ['Seat', 'Flat', 'Room'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PostController>(builder: (controller) {
        return Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    width: 120,
                    child: Image.asset('assets/icons/icon.png'),
                  ),
                  Text(
                    'Enter the below details to continue',
                    style: poppinsTextStyle(size: 12, color: bgColor),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 150,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(55),
                      topRight: Radius.circular(55)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black38,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      customTextField(
                          controller: _titleController,
                          hintText: 'Title',
                          icon: Icons.title),
                      customTextField(
                          controller: _locationController,
                          hintText: 'Location',
                          icon: Icons.location_city),
                      customTextField(
                        inputType: TextInputType.number,
                          controller: _priceController,
                          hintText: 'Price',
                          icon: Icons.price_change),
                      Card(
                        elevation: 1,
                        child: DropdownButtonFormField(
                          value: controller.category,
                          onChanged: controller.pickCategory,
                          items: items
                              .map((valueItem) => DropdownMenuItem(
                              value: valueItem,
                              child: Text(
                                valueItem,
                              )))
                              .toList(),
                          icon: Icon(Icons.arrow_drop_down_circle),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            prefixIcon: Icon(
                              Icons.category_rounded,
                              color: blackColor,
                            ),
                            labelText: 'Category',
                            labelStyle: TextStyle(color: Colors.grey.shade700),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.pickCamOrGallery(context);
                          // controller.pickAddImage(ImageSource.gallery);
                        },
                        child: Card(
                          elevation: 1,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(Icons.photo_rounded),
                                horizontalSpace,
                                controller.addImage == null
                                    ? Text(
                                  'Add Photo',
                                  style: TextStyle(
                                      color: Colors.grey.shade700),
                                )
                                    : Text('Change Photo',
                                    style: TextStyle(color: blackColor)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      customTextField(
                          inputType: TextInputType.multiline,
                          controller: _descriptionController,
                          hintText: 'Description',
                          icon: Icons.description),
                      verticalSpace,
                      customButton(
                          text: 'ADD',
                          onTap: () async{
                            QuerySnapshot userData = await FirebaseFirestore.instance.collection('landlords').where('uid', isEqualTo: _currentUser!.uid).get();

                            if (_locationController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Enter your location',
                                  toastLength: Toast.LENGTH_SHORT);
                            } else if (_priceController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Enter the price',
                                  toastLength: Toast.LENGTH_SHORT);
                            } else if (controller.addImage == null) {
                              Fluttertoast.showToast(
                                  msg: 'Add a photo',
                                  toastLength: Toast.LENGTH_SHORT);
                            } else {
                              controller.addPost(
                                  context: context,
                                  currentUserUid: _currentUser!.uid,
                                  adOwnerUid: _currentUser!.uid,
                                  adOwnerPhone: '${userData.docs.single['phoneNumber']}',
                                  time: _currentTime,
                                  title: _titleController.text.trim(),
                                  category: controller.category,
                                  description:
                                  _descriptionController.text.trim(),
                                  location: _locationController.text.trim(),
                                  price: _priceController.text.trim());
                            }
                          }),
                      verticalSpace,
                      controller.addImage == null
                          ? Container()
                          : Container(
                        height: 200,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(controller.addImage!))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
