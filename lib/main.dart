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
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.4),
            currentIndex: currentPage,
            onTap: (index) {
              setState(() {
                currentPage = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(CupertinoIcons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.favorite_border_outlined),
                label: "Favorites",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
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
//https://api.themoviedb.org/3/discover/movie?api_key=THE_KEY&with_origin_country=IN


  // TabBar(
  //                       labelPadding: EdgeInsets.only(
  //                         right: size.width * .033,
  //                       ),
  //                       indicator: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(10),
  //                         color: Colors.black,
  //                       ),
  //                       unselectedLabelColor: Colors.black,
  //                       padding: EdgeInsets.only(left: size.width * .075),
  //                       isScrollable: true,
  //                       controller: _tabController,
  //                       tabs: [
  //                         Container(
  //                             margin: const EdgeInsets.only(left: 10),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(10),
  //                               border: Border.all(
  //                                   color: !_tabController.indexIsChanging
  //                                       ? Colors.black
  //                                       : Colors.black),
  //                             ),
  //                             width: size.width * .35,
  //                             height: size.height * .065,
  //                             child: Center(child: Text(categories[0].name))),
  //                         Container(
  //                             margin: const EdgeInsets.only(left: 10),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(10),
  //                               border: Border.all(
  //                                   color: !_tabController.indexIsChanging
  //                                       ? Colors.black
  //                                       : Colors.black),
  //                             ),
  //                             width: size.width * .35,
  //                             height: size.height * .065,
  //                             child: Center(child: Text(categories[1].name))),
  //                         Container(
  //                             margin: const EdgeInsets.only(left: 10),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(10),
  //                               border: Border.all(
  //                                   color: !_tabController.indexIsChanging
  //                                       ? Colors.black
  //                                       : Colors.black),
  //                             ),
  //                             width: size.width * .35,
  //                             height: size.height * .065,
  //                             child: Center(child: Text(categories[2].name))),
  //                         Container(
  //                             margin: const EdgeInsets.only(left: 10),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(10),
  //                               border: Border.all(
  //                                   color: !_tabController.indexIsChanging
  //                                       ? Colors.black
  //                                       : Colors.black),
  //                             ),
  //                             width: size.width * .35,
  //                             height: size.height * .065,
  //                             child: Center(child: Text(categories[3].name))),
  //                         Container(
  //                             margin: const EdgeInsets.only(left: 10),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(10),
  //                               border: Border.all(
  //                                   color: !_tabController.indexIsChanging
  //                                       ? Colors.black
  //                                       : Colors.black),
  //                             ),
  //                             width: size.width * .35,
  //                             height: size.height * .065,
  //                             child: Center(child: Text(categories[4].name))),
  //                         Container(
  //                             margin: const EdgeInsets.only(left: 10),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(10),
  //                               border: Border.all(
  //                                   color: !_tabController.indexIsChanging
  //                                       ? Colors.black
  //                                       : Colors.black),
  //                             ),
  //                             width: size.width * .35,
  //                             height: size.height * .065,
  //                             child: Center(child: Text(categories[5].name))),
  //                       ]),
  //                   SizedBox(
  //                     height: size.height * .03,
  //                   ),
  //                   Expanded(
  //                     child: Padding(
  //                       padding:
  //                           EdgeInsets.symmetric(horizontal: size.width * .065),
  //                       child: TabBarView(
  //                         controller: _tabController,
  //                         children: [
  //                           CategoryDataScreen(categoryId: categories[0].id!),
  //                           CategoryDataScreen(categoryId: categories[1].id!),
  //                           CategoryDataScreen(categoryId: categories[2].id!),
  //                           CategoryDataScreen(categoryId: categories[3].id!),
  //                           CategoryDataScreen(categoryId: categories[4].id!),
  //                           CategoryDataScreen(categoryId: categories[5].id!),
  //                         ],
  //                       ),
  //                     ),
  //                   ),