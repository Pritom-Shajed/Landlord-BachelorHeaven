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

List<Step> stepList(
        {required String locationTitle,
          required TextEditingController titleController,
        required TextEditingController locationController,
        required TextEditingController priceController,
        required TextEditingController descriptionController,
        required BuildContext context}) =>
    [

      Step(
        isActive: stepperController.currentStep.value <= 0,
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
            customTextField(
                controller: locationController,
                hintText: 'Location',
                icon: Icons.location_pin),
          ],
        ),
      ),
      Step(
          isActive: stepperController.currentStep.value <= 01,
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
        isActive: stepperController.currentStep.value <= 2,
        title: Text('Photo'),
        content: Column(
          children: [
            InkWell(
              onTap: () {
                postController.pickCamOrGallery(context);
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
                      postController.addImage == null
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
            postController.addImage == null
                ? Container()
                : Container(
                    height: 200,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(postController.addImage!))),
                  ),
          ],
        ),
      )
    ];