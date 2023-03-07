import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/model/booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  Booking booking = Booking.confirm;

  void cancelledBookings(){
    booking = Booking.cancel;
    update();
  }
  void confirmedBookings(){
    booking = Booking.confirm;
    update();
  }
  void requestedBookings(){
    booking = Booking.pending;
    update();
  }


  confirmBooking({
    required BuildContext context,
    required String bookingStatus,
    required String apartmentUid,
    required String adBookedByUid,
  }) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: LoadingIndicatorWhite);
        });
    ConfirmBookingModel confirmBookingModel = ConfirmBookingModel(
      bookingStatus: bookingStatus,
    );
    final CollectionReference ref =
    await FirebaseFirestore.instance.collection('Bookings');
    QuerySnapshot snapshot = await ref
        .where('apartmentUid', isEqualTo: apartmentUid)
        .where('adBookedByUid', isEqualTo: adBookedByUid)
        .get();

    snapshot.docs.forEach((element) {
      element.reference
          .update(confirmBookingModel.toJson())
          .then((value) => Fluttertoast.showToast(msg: 'Booking confirmed'))
          .then((value) => Get.offAllNamed('/dashboard'));
    });
  }

  cancelBooking({
    required String time,
    required BuildContext context,
    required String cancelled,
    required String apartmentUid,
    required String adBookedByUid,
    required String bookingStatus,
    required String adOwnerUid,
    required String checkIn,
    required String checkOut,
    required String persons,
    required String title,
    required String pictureUrl,

  }) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: LoadingIndicatorWhite);
        });
    CancelBookingModel cancelBookingModel = CancelBookingModel(
        cancelled: cancelled);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Bookings')
        .where('apartmentUid', isEqualTo: apartmentUid)
        .where('adBookedByUid', isEqualTo: adBookedByUid)
        .get();

    CancelBookingModelIndividual cancelBookingModelIndividual = CancelBookingModelIndividual(
        bookingStatus: bookingStatus,
        adOwnerUid: adOwnerUid,
        adBookedByUid: adBookedByUid,
        checkIn: checkIn,
        checkOut: checkOut,
        persons: persons,
        apartmentUid: apartmentUid,
        title: title,
        pictureUrl: pictureUrl);

    await
    FirebaseFirestore.instance.collection('CancelledBookings-Landlords').doc(
        time).set(cancelBookingModelIndividual.toJson()).then((value) =>
        FirebaseFirestore.instance.collection('CancelledBookings-User').doc(
            time).set(cancelBookingModelIndividual.toJson())).then((value) =>
        snapshot.docs.forEach((element) {
          element.reference.delete();
        })).then((value) => Fluttertoast.showToast(msg: 'Booking cancelled'))
        .then((value) => Get.offAllNamed('/dashboard'));


  }


// cancelBookingFromRequest({
//   required BuildContext context,
//   required String cancelled,
//   required String apartmentUid,
//   required String adBookedByUid,
// }) async {
//   showDialog(
//       context: context,
//       builder: (context) {
//         return Center(child: LoadingIndicatorWhite);
//       });
//   CancelBookingModel cancelBookingModel = CancelBookingModel(cancelled: cancelled);
//   QuerySnapshot snapshot = await FirebaseFirestore.instance
//       .collection('Bookings')
//       .where('apartmentUid', isEqualTo: apartmentUid)
//       .where('adBookedByUid', isEqualTo: adBookedByUid)
//       .get();
//
//   snapshot.docs.forEach((element) {
//     element.reference.update(cancelBookingModel.toJson()).then((value) => Fluttertoast.showToast(msg: 'Booking cancelled'))
//         .then((value) => Get.offAllNamed('/dashboard'));
//   });
// }
}
