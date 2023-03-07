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

class CancelBookingModel {
  String cancelled;

  CancelBookingModel({
    required this.cancelled,
  });

  Map<String, dynamic> toJson() {
    return {
      'cancelled': cancelled,
    };
  }
}
