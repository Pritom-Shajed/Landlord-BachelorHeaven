import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/auth/auth_controller.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_Button.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_textField.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegScreen extends StatelessWidget {
  RegScreen({super.key});

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: GetBuilder<AuthController>(builder: (controller) {
        return SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.only(top: 30),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Image.asset('assets/icons/icon.png'),
                        ),
                        horizontalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome!',
                              style: poppinsTextStyle(
                                  size: 24,
                                  fontWeight: FontWeight.bold,
                                  color: bgColor),
                            ),
                            Text(
                              'Enter your details to continue',
                              style: poppinsTextStyle(size: 12, color: bgColor),
                            ),
                          ],
                        )
                      ],
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
                        Stack(
                          children: [
                            controller.image == null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundColor: lightGreyColor,
                                    backgroundImage:
                                        AssetImage('assets/images/avatar.png'))
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundColor: lightGreyColor,
                                    backgroundImage:
                                        FileImage(controller.image!)),
                            controller.image == null
                                ? Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        controller.pickImage(ImageSource.gallery);
                                      },
                                      child: Icon(
                                        Icons.add_circle,
                                      ),
                                    ))
                                : Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        controller.pickImage(ImageSource.gallery);
                                      },
                                      child: Icon(
                                        Icons.change_circle,
                                      ),
                                    ))
                          ],
                        ),
                        verticalSpace,
                        customTextField(
                            controller: _nameController,
                            hintText: 'Username',
                            icon: Icons.account_box),
                        customTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            icon: Icons.email),
                        Obx(
                          () => customTextField(
                              maxLines: 1,
                              obscureText: controller.obscureText.value,
                              controller: _passController,
                              hintText: 'Password',
                              suffixIcon: controller.obscureText == true
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              suffixIconTap: () => controller.changeObscureText(
                                  controller.obscureText.value == true
                                      ? false
                                      : true),
                              icon: Icons.lock),
                        ),
                        customTextField(
                            inputType: TextInputType.number,
                            controller: _phoneController,
                            hintText: 'Phone Number',
                            icon: Icons.phone),
                        customTextField(
                            controller: _locationController,
                            hintText: 'City Name',
                            icon: Icons.location_city),
                        verticalSpace,
                        customButton(
                            text: 'Register',
                            onTap: () {
                              if (controller.image == null) {
                                Fluttertoast.showToast(
                                    msg: 'Add your profile photo');
                              } else if (_nameController.text.isEmpty) {
                                Fluttertoast.showToast(msg: 'Enter you name');
                              } else if (_emailController.text.isEmpty) {
                                Fluttertoast.showToast(msg: 'Enter you email');
                              } else if (_passController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: 'Enter your password');
                              } else if (_locationController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: 'Enter your city name');
                              } else {
                                controller.signUp(
                                  context: context,
                                  email:
                                      _emailController.text.toLowerCase().trim(),
                                  pass: _passController.text,
                                  name: _nameController.text.trim(),
                                  phoneNumber: _phoneController.text.trim(),
                                  location: _locationController.text.trim(),
                                );
                              }
                            }),
                        verticalSpace,
                        Center(
                          child: Text(
                            'By continuing, you agree to our Terms and Conditions',
                            style: poppinsTextStyle(color: greyColor, size: 12),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style:
                                  poppinsTextStyle(color: blackColor, size: 12),
                            ),
                            TextButton(
                              onPressed: () => Get.toNamed('/login'),
                              child: Text(
                                'Login Now',
                                style: poppinsTextStyle(size: 12),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    ));
  }
}
