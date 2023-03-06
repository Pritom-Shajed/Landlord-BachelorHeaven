import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/widgets/alert_dialog.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_Button.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBookings extends StatelessWidget {
   MyBookings({Key? key}) : super(key: key);

   FirebaseFirestore _firestore = FirebaseFirestore.instance;
   User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('Bookings')
            .where('adOwnerUid', isEqualTo: _currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> bookings =
                    snapshot.data!.docs[index].data();

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: CircleAvatar(
                                  radius: 30,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                bookings['pictureUrl']), fit: BoxFit.cover)),
                                  )),
                            ),
                            horizontalSpace,
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(bookings['title'], style: poppinsTextStyle(fontWeight: FontWeight.w600),),
                                  RichText(text: TextSpan(
                                      children: [
                                        TextSpan(text: 'Persons: ',style: poppinsTextStyle(color: blackColor),),
                                        TextSpan(text: bookings['persons'],style: poppinsTextStyle(color: blackColor),),
                                      ]
                                  )),
                                  RichText(text: TextSpan(
                                      children: [
                                        TextSpan(text: 'Check-in: ',style: poppinsTextStyle(color: blackColor),),
                                        TextSpan(text: bookings['checkIn'],style: poppinsTextStyle(color: blackColor),),
                                      ]
                                  )),
                                  RichText(text: TextSpan(
                                      children: [
                                        TextSpan(text: 'Check-out: ',style: poppinsTextStyle(color: blackColor),),
                                        TextSpan(text: bookings['checkIn'],style: poppinsTextStyle(color: blackColor),),
                                      ]
                                  )),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                  children: [
                                    customButton(color: indigoColor,text: 'Tap to confirm', onTap: ()=>alertDialog(context: context, title: 'Confirm booking?', onTapYes: (){}, onTapNo: ()=>Get.back())),
                                    verticalSpace,
                                    customButton(color: bgColor,text: 'Tap to cancel', onTap: ()=>alertDialog(context: context, title: 'Cancel booking?', onTapYes: (){}, onTapNo: ()=>Get.back())),
                                  ]
                              ),
                            )

                          ],
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error Occured'),
              );
            } else {
              return Center(
                child: Text('Something went wrong'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: blackColor,
              ),
            );
          }
        });
  }
}
