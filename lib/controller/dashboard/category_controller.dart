import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:get/get.dart';

class MyAdsController extends GetxController {
  Selected selected = Selected.flat;

  void flatSelected() {
    selected = Selected.flat;
    update();
  }

  void roomSelected() {
    selected = Selected.room;
    update();
  }

  void seatSelected() {
    selected = Selected.seat;
    update();
  }
}
