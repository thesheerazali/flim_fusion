import 'package:film_fusion/controller/favorite_screen_controller.dart';
import 'package:film_fusion/controller/home_screen_controller.dart';

import 'package:get/get.dart';






class ScreenBidings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController());
    Get.lazyPut(() => FavoriteMoviesController());

    // Get.lazyPut(() => SearchResyltController());
    
  }
}
