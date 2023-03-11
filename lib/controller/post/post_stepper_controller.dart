import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class StepperController extends GetxController {
  final _currentStep = 0.obs;
  RxList<Location> locations = <Location>[].obs;


   get currentStep => _currentStep.value;

  set currentStep(value) {
    _currentStep.value = value;
  }

  stepIncrement() {
    currentStep = currentStep + 1;
  }

  stepDecrement() {
    currentStep = currentStep - 1;
  }

  getLatLon(String input)async{
    try{
      locations.value =  await locationFromAddress(input);
    }catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }

  }

}
