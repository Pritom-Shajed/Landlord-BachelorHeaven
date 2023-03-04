import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/profile/profile_controller.dart';
import 'package:bachelor_heaven_landlord/model/user_model.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_Button.dart';
import 'package:bachelor_heaven_landlord/widgets/edit_profile.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfile extends StatelessWidget {
  MyProfile({super.key});

  final _currentUser = FirebaseAuth.instance.currentUser;
  ProfileController _controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
        body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            DocumentSnapshot<Map<String, dynamic>> userData = snapshot.data!;

            final _name = TextEditingController(text: userData['name']);
            final _email = TextEditingController(text: userData['email']);
            final _location = TextEditingController(text: userData['location']);
            final _phone = TextEditingController(text: userData['phoneNumber']);

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
                    ],
                  ),
                ),
                Positioned(
                  top: 130,
                  bottom: 0,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: lightGreyColor,
                              backgroundImage:
                                  NetworkImage(userData['profilePic']),
                            ),
                            verticalSpace,
                            Text(
                              '${userData['name']}',
                              style: poppinsTextStyle(color: bgColor,
                                  size: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Joined: ${userData['joinedDate']}',
                              style: poppinsTextStyle(
                                  color: greyColor,
                                  size: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            verticalSpace,
                            Container(
                              padding: EdgeInsets.all(10),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  border: Border.all(color: bgColor),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email:',
                                    style: poppinsTextStyle(color: bgColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${userData['email']}',
                                    style: poppinsTextStyle(color: bgColor,size: 15),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpace,
                            Container(
                              padding: EdgeInsets.all(10),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  border: Border.all(color: bgColor),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Phone Number:',
                                    style: poppinsTextStyle(
                                      color: bgColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${userData['phoneNumber']}',
                                    style: poppinsTextStyle(color: bgColor,size: 15),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpace,
                            Container(
                              padding: EdgeInsets.all(10),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  border: Border.all(color: bgColor),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Location:',
                                    style: poppinsTextStyle(color: bgColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${userData['location']}',
                                    style: poppinsTextStyle(color: bgColor,size: 15),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpace,
                            Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: customButton(
                                      text: 'Edit Profile',
                                      onTap: () => editProfileDialog(
                                          context: context,
                                          nameController: _name,
                                          emailController: _email,
                                          phoneController: _phone,
                                          locationController: _location,
                                          onTap: () async {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (_) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    color: whiteColor,
                                                  ));
                                                });
                                            final user = UserModel(
                                                name: _name.text.trim(),
                                                email: _email.text.trim(),
                                                profilePic:
                                                    userData['profilePic'],
                                                uid: userData['uid'],
                                                location: _location.text.trim(),
                                                phoneNumber: _phone.text.trim(),
                                                joinedDate:
                                                    userData['joinedDate']);
                                            await FirebaseAuth
                                                .instance.currentUser!
                                                .updateDisplayName(
                                                    _name.text.trim())
                                                .then((value) => _controller
                                                    .updateUserDetails(user))
                                                .then((value) =>
                                                    Get.offAllNamed(
                                                        '/dashboard'));
                                          }),
                                    )),
                                horizontalSpace,
                                Expanded(
                                  flex: 1,
                                  child: customButton(
                                      color: redColor,
                                      text: 'Delete Profile',
                                      onTap: () {
                                        print('edit');
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString(), style: poppinsTextStyle(color: whiteColor),),
            );
          } else {
            return Center(
              child: Text('Something Went Wrong', style: poppinsTextStyle(color: whiteColor),),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
