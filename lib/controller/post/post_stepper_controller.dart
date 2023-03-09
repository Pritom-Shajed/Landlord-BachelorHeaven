import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class StepperController extends GetxController {
  RxInt currentStep = 0.obs;
  RxList<Location> locations = <Location>[].obs;


  stepIncrement() {
    currentStep.value = currentStep.value + 1;
  }

  stepDecrement() {
    currentStep.value = currentStep.value - 1;
  }

  getLatLon(String input)async{
    try{
      locations.value =  await locationFromAddress(input);
    }catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }

  }

}
