import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/widgets/alert_dialog.dart';
import 'package:bachelor_heaven_landlord/widgets/bookingCard.dart';
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
                          return ListView.separated(
                            separatorBuilder: (context, index){
                              return Divider(color: shadowColor,);
                            },
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> bookings =
                                    snapshot.data!.docs[index].data();
                                return BookingCardCancelled(
                                    onTap: () {
                                      return alertDialog(
                                          context: context,
                                          title: 'Delete?',
                                          onTapYes: () async {
                                            QuerySnapshot snapshot =
                                            await FirebaseFirestore
                                                .instance
                                                .collection('CancelledBookings-Landlords').where('adOwnerUid',
                                                isEqualTo:_currentUser!.uid).where('bookingUid',
                                                isEqualTo: bookings['bookingUid']).get();
                                            snapshot.docs.forEach((element) {
                                              element.reference.delete();
                                            });
                                            Get.back();
                                          },
                                          onTapNo: () {
                                            Get.back();
                                          });
                                    },
                                    context: context,
                                    imageUrl: bookings['pictureUrl'],
                                    apartmentTitle: bookings['title'],
                                    personsTotal: bookings['persons'],
                                    location: bookings['address'],
                                    price: bookings['price'],
                                    category: 'Seat',
                                    buttonOne: bookingButtonContainer(
                                        color: bgColor,
                                        text: 'Cancelled'),
                                    buttonTwo: Container());
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
                          return ListView.separated(
                            separatorBuilder: (context, index){
                              return Divider(color: shadowColor,);
                            },
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> bookings =
                                    snapshot.data!.docs[index].data();
                                return BookingCardNormal(
                                    context: context,
                                    imageUrl: bookings['pictureUrl'],
                                    apartmentTitle: bookings['title'],
                                    personsTotal: bookings['persons'],
                                    location: bookings['address'],
                                    price: bookings['price'],
                                    category: 'Seat',
                                    cancelled: bookings['cancelled'],
                                    bookingStatus:
                                    bookings['bookingStatus'],
                                    buttonOne: bookings['bookingStatus'] ==
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
                                    buttonTwo: customButton(
                                        color: bookings['cancelled'] == 'No' ? bgColor:deepBrown,
                                        text: bookings['cancelled'] == 'No' ? 'Cancel' : 'Requested to cancel',
                                        onTap: () => alertDialog(
                                            context: context,
                                            title: 'Cancel booking?',
                                            onTapYes: () =>
                                                controller.cancelBooking(
                                                  context: context,
                                                  cancelled: 'Yes',
                                                  price: bookings['price'],
                                                  category: bookings['category'],
                                                  address: bookings['address'],
                                                  bookingUid: bookings['bookingUid'],
                                                  adBookedByUid:
                                                  bookings[
                                                  'adBookedByUid'],
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
                                                Get.back())));
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
