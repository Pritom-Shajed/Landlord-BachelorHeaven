import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/post/location_controller.dart';
import 'package:bachelor_heaven_landlord/controller/post/post_controller.dart';
import 'package:bachelor_heaven_landlord/controller/post/post_stepper_controller.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

PostController postController = Get.find();
StepperController stepperController = Get.find();
LocationController controller = Get.put(LocationController());
final List<String> items = ['Seat', 'Flat', 'Room'];
final List<String> divisions = [
  'Dhaka',
  'Chattogram',
  'Sylhet',
  'Khulna',
  'Rajshahi',
  'Rangpur',
  'Mymensingh',
  'Barishal',
];

List<Step> stepList(
        {required String locationTitle,
        required TextEditingController titleController,
        required TextEditingController addressController,
        required TextEditingController priceController,
        required TextEditingController descriptionController,
        required BuildContext context}) =>
    [
      Step(
        state: stepperController.currentStep == 0 ? StepState.complete: StepState.disabled,
        isActive: stepperController.currentStep == 0,
        title: Text('Initial'),
        content: Column(
          children: [
            customTextField(
                controller: titleController,
                hintText: 'Title',
                icon: Icons.title),
            customTextField(
                inputType: TextInputType.number,
                controller: priceController,
                hintText: 'Price',
                icon: Icons.price_change),
            Card(
              elevation: 1,
              child: DropdownButtonFormField(
                value: postController.division,
                onChanged: postController.pickDivision,
                items: divisions
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
                    Icons.location_city,
                    color: blackColor,
                  ),
                  labelText: 'Division',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: InputBorder.none,
                ),
              ),
            ),
            customTextField(
                controller: addressController,
                hintText: 'Address',
                icon: Icons.location_pin),
          ],
        ),
      ),
      Step(
        state: stepperController.currentStep == 1 ? StepState.complete: StepState.disabled,
          isActive: stepperController.currentStep == 1,
          title: Text('Description'),
          content: Column(
            children: [
              Card(
                elevation: 1,
                child: DropdownButtonFormField(
                  value: postController.category,
                  onChanged: postController.pickCategory,
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
              customTextField(
                  inputType: TextInputType.multiline,
                  controller: descriptionController,
                  hintText: 'Description',
                  icon: Icons.description),
            ],
          )),
      Step(
state: stepperController.currentStep == 2 ? StepState.complete: StepState.disabled,
        isActive: stepperController.currentStep == 2,
        title: Text('Photo'),
        content: Column(
          children: [
            InkWell(
              onTap: () {
                postController.pickCamOrGallery(context);
              },
              child: Card(
                elevation: 1,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(Icons.photo_rounded),
                      horizontalSpace,
                      postController.myFile.path == null
                          ? Text(
                              'Add Photo',
                              style: TextStyle(color: Colors.grey.shade700),
                            )
                          : Text('Change Photo',
                              style: TextStyle(color: blackColor)),
                    ],
                  ),
                ),
              ),
            ),
            postController.myFile.path == null
                ? Container()
                : Container(
                    height: 200,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(postController.myFile.image!))),
                  ),
          ],
        ),
      )
    ];
