
import 'package:bachelor_heaven_landlord/controller/dashboard/category_controller.dart';
import 'package:bachelor_heaven_landlord/controller/dashboard/post_controller.dart';
import 'package:bachelor_heaven_landlord/controller/intial/dashboard_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(MyAdsController());
    Get.put(PostController());
  }
}
//
// class AuthBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(AuthController());
//   }
// }
//
// class PostAddBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(PostController());
//   }
// }
