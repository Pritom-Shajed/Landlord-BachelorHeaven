import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class StepperController extends GetxController {
  RxInt currentStep = 0.obs;


  stepIncrement() {
    currentStep.value = currentStep.value + 1;
  }

  stepDecrement() {
    currentStep.value = currentStep.value - 1;
  }



}
