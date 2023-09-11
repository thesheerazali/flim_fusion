import 'package:film_fusion/constants/routes.dart';
import 'package:film_fusion/screens/favorite/fav_screen.dart';
import 'package:film_fusion/screens/home/home_screen.dart';
import 'package:film_fusion/screens/profile/profile_screen.dart';
import 'package:film_fusion/screens/stream/stream_screen.dart';
import 'package:film_fusion/utils/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
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
      initialRoute: splash,
      getPages: RouteGenerator.getPages(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;

  List<Widget> pages = [
    const HomeScreen(),
    const StreamScreen(),
    FavScreen(),
    ProfileScreen(),
  ];

  DateTime? currentBackPressTime; // Add this variable

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press
        if (currentPage != 0) {
          setState(() {
            currentPage = 0;
          });

          // Update the active tab
          return false; // Prevent the default back navigation
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: pages[currentPage],
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black.withOpacity(0.4),
            currentIndex: currentPage,
            onTap: (index) {
              setState(() {
                currentPage = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.cart),
                label: "Cart",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_outlined),
                label: "Favorites",
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// class MainPage extends StatefulWidget {
//   const MainPage({
//     super.key,
//   });

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   static int currentPage = 0;
//   List<Widget> pages = [
//    const HomeScreen(),
//     const StreamScreen(),
//     const FavScreen(),
//     const ProfileScreen(),
//   ];

//   DateTime? currentBackPressTime;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Color(0xfffe6d29),
//       body: WillPopScope(
//         onWillPop: () async {
//           // Handle the back button press
//           if (currentPage != 0) {
//             setState(() {
//               currentPage = 0;
//             });
//             return false; // Prevent the default back navigation
//           }
//           if (currentBackPressTime == null ||
//               DateTime.now().difference(currentBackPressTime!) >
//                   Duration(seconds: 2)) {
//             currentBackPressTime = DateTime.now();
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text("Press back again to leave"),
//               ),
//             );
//             return false;
//           }
//           return true; // Allow the back button to execute
//         },
//         child: pages[currentPage],
//       ),
//       resizeToAvoidBottomInset: false,
//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: size.width * .03,
//         ),
//         child: GNav(
//           backgroundColor: Color(0xfffe6d29),

//           activeColor: Color.fromARGB(255, 231, 228, 228),
//           // tabBackgroundColor: Colors.blue,
//           onTabChange: (value) {
//             currentPage = value;
//             setState(() {});
//           },

//           tabs: [
//             const GButton(
//               icon: CupertinoIcons.home,
//               text: "Home",
//               textStyle: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Color.fromARGB(255, 231, 228, 228),
//                   fontSize: 18),
//             ),
//             const GButton(
//               icon: CupertinoIcons.cart,
//               text: "Cart",
//             ),
//             const GButton(
//               icon: Icons.favorite_border_outlined,
//               text: "Favorites",
//             ),
//             GButton(
//               padding: EdgeInsets.only(right: size.width * .07),
//               icon: CupertinoIcons.person,
//               text: "Profile",
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
