import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/booking/booking_controller.dart';
import 'package:bachelor_heaven_landlord/widgets/alert_dialog.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_Button.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_container.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyBookings extends StatelessWidget {
  MyBookings({Key? key}) : super(key: key);

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser = FirebaseAuth.instance.currentUser;
  ConfirmBookingController _controller = Get.find();
  String _currentTime =
      DateFormat.yMMMMd('en_US').add_jms().format(DateTime.now());

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
                                                bookings['pictureUrl']),
                                            fit: BoxFit.cover)),
                                  )),
                            ),
                            horizontalSpace,
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bookings['title'],
                                    style: poppinsTextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                      text: 'Persons: ',
                                      style:
                                          poppinsTextStyle(color: blackColor),
                                    ),
                                    TextSpan(
                                      text: bookings['persons'],
                                      style:
                                          poppinsTextStyle(color: blackColor),
                                    ),
                                  ])),
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                      text: 'Check-in: ',
                                      style:
                                          poppinsTextStyle(color: blackColor),
                                    ),
                                    TextSpan(
                                      text: bookings['checkIn'],
                                      style:
                                          poppinsTextStyle(color: blackColor),
                                    ),
                                  ])),
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                      text: 'Check-out: ',
                                      style:
                                          poppinsTextStyle(color: blackColor),
                                    ),
                                    TextSpan(
                                      text: bookings['checkIn'],
                                      style:
                                          poppinsTextStyle(color: blackColor),
                                    ),
                                  ])),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: bookings['cancelled'] == 'No'
                                  ? Column(children: [
                                      bookings['bookingStatus'] == 'Pending'
                                          ? customButton(
                                              color: indigoColor,
                                              text: 'Confirm',
                                              onTap: () => alertDialog(
                                                  context: context,
                                                  title: bookings['bookingStatus'] == 'Pending' ? 'Cancel booking?':'Booking is already confirmed. Cancel ?',
                                                  onTapYes: () {
                                                    _controller.confirmBooking(
                                                      context: context,
                                                      adBookedByUid: bookings[
                                                          'adBookedByUid'],
                                                      bookingStatus:
                                                          'Confirmed',
                                                      apartmentUid: bookings[
                                                          'apartmentUid'],
                                                    );
                                                  },
                                                  onTapNo: () => Get.back()))
                                          : customConatiner(
                                              color: greenColor,
                                              text: bookings['bookingStatus']),
                                      verticalSpace,
                                      customButton(
                                          color: bgColor,
                                          text: 'Cancel',
                                          onTap: () => alertDialog(
                                              context: context,
                                              title: 'Cancel booking?',
                                              onTapYes: () =>
                                                  _controller.cancelBooking(
                                                      context: context,
                                                      cancelled: 'Yes',
                                                    adBookedByUid: bookings[
                                                    'adBookedByUid'],
                                                    apartmentUid: bookings[
                                                    'apartmentUid'],),
                                              onTapNo: () => Get.back())),
                                    ])
                                  : bookings['cancelled'] == 'Requested'
                                      ? customButton(
                                          color: deepBrown,
                                          text: 'Requested to cancel',
                                          onTap: () => alertDialog(
                                              context: context,
                                              title: 'Cancel booking?',
                                              onTapYes: () => _controller
                                                      .cancelBookingFromRequest(
                                                    context: context,
                                                    cancelled: 'Yes',
                                                    adBookedByUid: bookings[
                                                        'adBookedByUid'],
                                                    apartmentUid: bookings[
                                                        'apartmentUid'],
                                                  ),
                                              onTapNo: () => Get.back()))
                                      : customConatiner(
                                          color: bgColor, text: 'Cancelled'),
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
