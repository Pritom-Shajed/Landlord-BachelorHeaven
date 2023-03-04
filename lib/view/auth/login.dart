import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/auth/auth_controller.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_Button.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_textField.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<AuthController>(
          builder: (controller) {
            return Stack(
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
                                'Login Now',
                                style: poppinsTextStyle(
                                    size: 24,
                                    fontWeight: FontWeight.bold,
                                    color: bgColor),
                              ),
                              Text(
                                'We missed you!',
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
                          SizedBox(
                            width: 160,
                            child: Image.asset('assets/images/sign-in.png'),
                          ),
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
                                icon: Icons.lock,
                                suffixIcon: controller.obscureText == true ? Icons.visibility_off : Icons.visibility,
                                suffixIconTap: ()=>controller.changeObscureText(controller.obscureText.value == true ? false : true)),

                          ),
                          verticalSpace,
                          customButton(
                              text: 'Login',
                              onTap: () {
                                controller.singIn(
                                    context: context,
                                    email: _emailController.text,
                                    pass: _passController.text);
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New Here?',
                                style: poppinsTextStyle(color: blackColor, size: 12),
                              ),
                              TextButton(
                                onPressed: ()=>Get.toNamed('/registration'),
                                child: Text(
                                  'Register Now',
                                  style: poppinsTextStyle( size: 12),
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
            );
          },
        ),
      ),
    );
  }
}
