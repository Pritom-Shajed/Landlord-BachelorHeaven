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

class CancelBookingModelIndividual {
  String bookingStatus;
  String adOwnerUid;
  String checkIn;
  String checkOut;
  String persons;
  String adBookedByUid;
  String apartmentUid;
  String title;
  String pictureUrl;

  CancelBookingModelIndividual({
    required this.bookingStatus,
    required this.adOwnerUid,
    required this.adBookedByUid,
    required this.checkIn,
    required this.checkOut,
    required this.persons,
    required this.apartmentUid,
    required this.title,
    required this.pictureUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingStatus': bookingStatus,
      'adOwnerUid': adOwnerUid,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'persons': persons,
      'adBookedByUid': adBookedByUid,
      'apartmentUid': apartmentUid,
      'title': title,
      'pictureUrl': pictureUrl,
    };
  }
}