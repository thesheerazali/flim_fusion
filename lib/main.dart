import 'package:film_fusion/constants/routes.dart';
import 'package:film_fusion/utils/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: homeScreen,
      getPages: RouteGenerator.getPages(),
    );
  }
}
