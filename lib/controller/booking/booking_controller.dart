import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/model/confirm_booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ConfirmBookingController extends GetxController {
  ConfirmBooking({
    required BuildContext context,
    required String bookingStatus,
    required String apartmentUid,
    required String adBookedByUid,
  }) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: LoadingIndicatorWhite
          );
        });
    ConfirmBookingModel confirmBookingModel = ConfirmBookingModel(
      bookingStatus: bookingStatus,
    );
    final CollectionReference ref = await FirebaseFirestore.instance
        .collection('Bookings');
    QuerySnapshot snapshot = await ref.where('apartmentUid', isEqualTo: apartmentUid).where('adBookedByUid', isEqualTo: adBookedByUid).get();

    snapshot.docs.forEach((element) {
      element.reference.update(confirmBookingModel.toJson()).then((value) => Fluttertoast.showToast(msg: 'Booking confirmed'))
          .then((value) => Get.offAllNamed('/dashboard'));
    });

  }
}
