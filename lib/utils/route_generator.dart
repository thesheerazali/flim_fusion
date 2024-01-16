import 'package:film_fusion/main.dart';
import 'package:film_fusion/screens/auth/sign_up_screen.dart';
import 'package:film_fusion/screens/favorite/fav_screen.dart';
import 'package:film_fusion/screens/home/detailScreen/detail_screen.dart';
import 'package:film_fusion/screens/home/home_screen.dart';
import 'package:film_fusion/screens/home/splash/splash_screen.dart';

import 'package:get/get.dart';

import '../screens/auth/login_screen.dart';

class RouteGenerator {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: '/splash',
        page: () => const SplashScreen(),
      ),
      GetPage(
        name: '/login',
        page: () => LoginScreen(),
      ),
      GetPage(
        name: '/signup',
        page: () => SignUpScreen(),
      ),
      GetPage(
        name: '/main',
        page: () => const MainPage(),
      ),
      GetPage(
        name: '/home',
        page: () => const HomeScreen(),
      ),
      GetPage(
        name: '/detail',
        page: () => const MovieDetailScreen(),
      ),
      GetPage(
        name: '/fav',
        page: () => FavScreen(),
      )
    ];
  }
}
