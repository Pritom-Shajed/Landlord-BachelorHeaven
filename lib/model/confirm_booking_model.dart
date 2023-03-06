class ConfirmBookingModel {
  String bookingStatus;

  ConfirmBookingModel({
    required this.bookingStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingStatus': bookingStatus,
    };
  }
}
