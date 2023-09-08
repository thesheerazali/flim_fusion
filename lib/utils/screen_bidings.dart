import 'package:film_fusion/controller/home_screen_controller.dart';

import 'package:get/get.dart';



import '../controller/login_screen_controller.dart';


class ScreenBidings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController());

    // Get.lazyPut(() => SearchResyltController());
    
  }
}
