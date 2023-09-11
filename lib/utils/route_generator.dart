

import 'package:film_fusion/main.dart';
import 'package:film_fusion/screens/auth/sign_up_screen.dart';
import 'package:film_fusion/screens/favorite/fav_screen.dart';
import 'package:film_fusion/screens/home/detailScreen/detail_screen.dart';
import 'package:film_fusion/screens/home/home_screen.dart';
import 'package:film_fusion/screens/home/splash/splash_screen.dart';
import 'package:film_fusion/utils/screen_bidings.dart';
import 'package:get/get.dart';

import '../screens/auth/login_screen.dart';

class RouteGenerator {
  static List<GetPage> getPages() {
    return [

        GetPage(
          name: '/splash', page: () => const SplashScreen(), binding: ScreenBidings()),
       GetPage(
          name: '/login', page: () => const LoginScreen(), binding: ScreenBidings()),
    
      GetPage(
          name: '/signup', page: () => const SignUpScreen(), binding: ScreenBidings())
          ,

           GetPage(
          name: '/main', page: () => const MainPage(), binding: ScreenBidings()),
      GetPage(
          name: '/home', page: () =>  HomeScreen(), binding: ScreenBidings()),
     GetPage(
          name: '/detail', page: () =>  MovieDetailScreen(), binding: ScreenBidings()),
            GetPage(
          name: '/fav', page: () =>  FavScreen(), binding: ScreenBidings())
    ];
  }
}
