import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/widgets/alert_dialog.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_Button.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_container.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/booking/booking_controller.dart';

class MyBookings extends StatelessWidget {
  MyBookings({Key? key}) : super(key: key);

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser = FirebaseAuth.instance.currentUser;
  String _currentTime =
      DateFormat.yMMMMd('en_US').add_jms().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(builder: (controller) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: controller.confirmedBookings,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        color: controller.booking == Booking.confirm
                            ? blackColor
                            : whiteColor,
                        border: Border.all(color: blackColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'Confirmed',
                      style: poppinsTextStyle(
                          color: controller.booking == Booking.confirm
                              ? whiteColor
                              : blackColor),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: controller.requestedBookings,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        color: controller.booking == Booking.pending
                            ? blackColor
                            : whiteColor,
                        border: Border.all(color: blackColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'Pending',
                      style: poppinsTextStyle(
                          color: controller.booking == Booking.pending
                              ? whiteColor
                              : blackColor),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: controller.cancelledBookings,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                        color: controller.booking == Booking.cancel
                            ? blackColor
                            : whiteColor,
                        border: Border.all(color: blackColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'Cancelled',
                      style: poppinsTextStyle(
                          color: controller.booking == Booking.cancel
                              ? whiteColor
                              : blackColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: controller.booking == Booking.cancel
                ? StreamBuilder(
                    stream: _firestore
                        .collection('CancelledBookings-Landlords')
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                            bookings[
                                                                'pictureUrl']),
                                                        fit: BoxFit.cover)),
                                              )),
                                        ),
                                        horizontalSpace,
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                bookings['title'],
                                                style: poppinsTextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                  text: 'Persons: ',
                                                  style: poppinsTextStyle(
                                                      color: blackColor),
                                                ),
                                                TextSpan(
                                                  text: bookings['persons'],
                                                  style: poppinsTextStyle(
                                                      color: blackColor),
                                                ),
                                              ])),
                                              RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                  text: 'Check-in: ',
                                                  style: poppinsTextStyle(
                                                      color: blackColor),
                                                ),
                                                TextSpan(
                                                  text: bookings['checkIn'],
                                                  style: poppinsTextStyle(
                                                      color: blackColor),
                                                ),
                                              ])),
                                              RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                  text: 'Check-out: ',
                                                  style: poppinsTextStyle(
                                                      color: blackColor),
                                                ),
                                                TextSpan(
                                                  text: bookings['checkOut'],
                                                  style: poppinsTextStyle(
                                                      color: blackColor),
                                                ),
                                              ])),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                customConatiner(
                                                    color: deepBrown,
                                                    text: 'Cancelled'),
                                                verticalSpace,
                                                customButton(
                                                    color: bgColor,
                                                    text: 'Delete',
                                                    onTap: () {})
                                              ],
                                            ))
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
                    })
                : StreamBuilder(
                    stream: _firestore
                        .collection('Bookings')
                        .where('adOwnerUid', isEqualTo: _currentUser!.uid)
                        .where('bookingStatus',
                            isEqualTo: controller.booking == Booking.pending
                                ? 'Pending'
                                : controller.booking == Booking.confirm
                                    ? 'Confirmed'
                                    : '')
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                            bookings[
                                                                'pictureUrl']),
                                                        fit: BoxFit.cover)),
                                              )),
                                        ),
                                        horizontalSpace,
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                bookings['title'],
                                                style: poppinsTextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                  text: 'Persons: ',
                                                  style: poppinsTextStyle(
                                                      color: blackColor),
                                                ),
                                                TextSpan(
                                                  text: bookings['persons'],
                                                  style: poppinsTextStyle(
                                                      color: blackColor),
                                                ),
                                              ])),
                                              RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                  text: 'Check-in: ',
                                                  style: poppinsTextStyle(
                                                      color: blackColor),
                                                ),
                                                TextSpan(
                                                  text: bookings['checkIn'],
                                                  style: poppinsTextStyle(
                                                      color: blackColor),
                                                ),
                                              ])),
                                              RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                  text: 'Check-out: ',
                                                  style: poppinsTextStyle(
                                                      color: blackColor),
                                                ),
                                                TextSpan(
                                                  text: bookings['checkOut'],
                                                  style: poppinsTextStyle(
                                                      color: blackColor),
                                                ),
                                              ])),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(children: [
                                            bookings['cancelled'] == 'Requested'
                                                ? Container()
                                                : bookings['bookingStatus'] ==
                                                        'Pending'
                                                    ? customButton(
                                                        color: indigoColor,
                                                        text: 'Confirm',
                                                        onTap: () =>
                                                            alertDialog(
                                                                context:
                                                                    context,
                                                                title: bookings[
                                                                            'bookingStatus'] ==
                                                                        'Pending'
                                                                    ? 'Cancel booking?'
                                                                    : 'Booking is already confirmed. Cancel ?',
                                                                onTapYes: () {
                                                                  controller
                                                                      .confirmBooking(
                                                                    context:
                                                                        context,
                                                                    bookingUid: bookings['bookingUid'],
                                                                    adBookedByUid:
                                                                        bookings[
                                                                            'adBookedByUid'],
                                                                    bookingStatus:
                                                                        'Confirmed',
                                                                    apartmentUid:
                                                                        bookings[
                                                                            'apartmentUid'],
                                                                  );
                                                                },
                                                                onTapNo: () =>
                                                                    Get.back()))
                                                    : customConatiner(
                                                        color: greenColor,
                                                        text: bookings[
                                                            'bookingStatus']),
                                            verticalSpace,
                                            bookings['bookingStatus'] ==
                                                    'Confirmed'
                                                ? Container()
                                                : customButton(
                                                    color: bookings['cancelled'] == 'No' ? bgColor:deepBrown,
                                                    text: bookings['cancelled'] == 'No' ? 'Cancel' : 'Requested to cancel',
                                                    onTap: () => alertDialog(
                                                        context: context,
                                                        title: 'Cancel booking?',
                                                        onTapYes: () =>
                                                            controller
                                                                .cancelBooking(
                                                              context: context,
                                                              cancelled: 'Yes',
                                                              bookingUid: bookings['bookingUid'],
                                                              adBookedByUid:
                                                                  bookings[
                                                                      'adBookedByUid'],
                                                              apartmentUid:
                                                                  bookings[
                                                                      'apartmentUid'],
                                                              time:
                                                                  _currentTime,
                                                              bookingStatus:
                                                                  'Cancelled',
                                                              adOwnerUid: bookings[
                                                                  'adOwnerUid'],
                                                              checkIn: bookings[
                                                                  'checkIn'],
                                                              checkOut: bookings[
                                                                  'checkOut'],
                                                              persons: bookings[
                                                                  'persons'],
                                                              title: bookings[
                                                                  'title'],
                                                              pictureUrl: bookings[
                                                                  'pictureUrl'],
                                                            ),
                                                        onTapNo: () =>
                                                            Get.back())),
                                          ]),
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
                    }),
          ),
        ],
      );
    });
  }
}
