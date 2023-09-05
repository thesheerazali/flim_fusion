

import 'package:film_fusion/screens/auth/sign_up_screen.dart';
import 'package:film_fusion/screens/home/home_screen.dart';
import 'package:film_fusion/utils/screen_bidings.dart';
import 'package:get/get.dart';

import '../screens/auth/login_screen.dart';

class RouteGenerator {
  static List<GetPage> getPages() {
    return [
       GetPage(
          name: '/login', page: () => const LoginScreen(), binding: ScreenBidings()),
    
      GetPage(
          name: '/signup', page: () => const SignUpScreen(), binding: ScreenBidings()),
      GetPage(
          name: '/home', page: () =>  HomeScreen(), binding: ScreenBidings())
    ];
  }
}
