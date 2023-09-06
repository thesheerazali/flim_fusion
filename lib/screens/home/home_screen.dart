// lib/views/trending_movies_view.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_fusion/screens/home/widgets/header.dart';
import 'package:film_fusion/screens/home/widgets/latest_movie_poster.dart';
import 'package:film_fusion/screens/home/widgets/search_movies_textfield.dart';
import 'package:film_fusion/screens/home/widgets/section_title.dart';
import 'package:film_fusion/screens/home/widgets/trending_movie_poster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/home_screen_controller.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * .07,
                    ),
                    const HomePageHeader(),
                    SizedBox(
                      height: Get.height * .035,
                    ),
                    const SearchMoviesTextField(),
                    SizedBox(
                      height: Get.height * .035,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(title: "New Movies"),
                          SizedBox(
                            height: Get.height * .035,
                          ),
                          LatestMoviePoster(),
                          SizedBox(
                            height: Get.height * .035,
                          ),
                          const SectionTitle(title: "Trending Movies"),
                          SizedBox(
                            height: Get.height * .035,
                          ),
                          TrendingMoviePosters(),
                        ],
                      ),
                    ))
                  ],
                ),
              );
            }
          })),
    );
  }
}










// class CustomContainerClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();

//     // Define the width at the top and bottom
//     final double topWidth = 200.0;
//     final double bottomWidth = 50.0;

//     // Start from the top-left corner
//     path.moveTo(0, 0);

//     // Line to the top-right corner with variable width
//     path.lineTo(size.width - (topWidth - bottomWidth) / 2, 0);

//     // Line to the bottom-right corner with a horizontal line
//     path.lineTo(size.width - bottomWidth / 2, size.height);
//     path.lineTo((topWidth - bottomWidth) / 2, size.height);

//     // Line to the bottom-left corner with variable width
//     path.lineTo(bottomWidth / 2, size.height - 1);
//     path.lineTo(0, 1);

//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }



//latest Movies Display//

//  Obx(
//         () {
//           if (controller.isLoading.value) {
//             return Center(child: CircularProgressIndicator());
//           } else {
//             return ListView.builder(
//               itemCount: controller.latestMovies.length,
//               itemBuilder: (context, index) {
//                 final movie = controller.latestMovies[index];
//                 debugPrint(controller.latestMovies.length.toString());
//                 return ListTile(
                  // leading: CachedNetworkImage(
                  //   imageUrl:
                  //       'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                  //   placeholder: (context, url) => CircularProgressIndicator(),
                  //   errorWidget: (context, url, error) => Icon(Icons.error),
                  // ),
//                   title: Text(movie.title),
//                   //   subtitle: Text(movie.releaseDate.timeZoneName),
//                   onTap: () {
//                     // Handle movie item tap here
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),


// // lib/screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../controller/home_screen_controller.dart';
// import '../../model/trending_movies_model.dart';
// import '../../model/new_movies_model.dart';

// class HomeScreen extends GetView<HomeScreenController> {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Movie App'),
//       ),
      // body: Obx(() {
      //   if (controller.isLoading.value) {
      //     return Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   } else {
      //     return ListView(
//             children: [
//               SectionTitle('Trending Movies'),
//               MovieList(controller.trendingMovies),
//               SectionTitle('New Movies'),
//               NewMovieList(controller.newMovies),
//             ],
//           );
//         }
//       }),
//     );
//   }
// }

// class SectionTitle extends StatelessWidget {
//   final String title;

//   SectionTitle(this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
      // child: Text(
      //   title,
      //   style: TextStyle(
      //     fontSize: 18,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
//     );
//   }
// }

// class MovieList extends StatelessWidget {
//   final RxList<Result> movies;

//   MovieList(this.movies);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: movies.length,
//         itemBuilder: (context, index) {
//           final movie = movies[index];
//           return MovieCard(movie);
//         },
//       ),
//     );
//   }
// }

// class NewMovieList extends StatelessWidget {
//   final RxList<NewMovie> newMovies;

//   NewMovieList(this.newMovies);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: newMovies.map((newMovie) => NewMovieCard(newMovie)).toList(),
//     );
//   }
// }

// class MovieCard extends StatelessWidget {
//   final Result movie;

//   MovieCard(this.movie);

//   @override
//   Widget build(BuildContext context) {
    // return Container(
    //   width: 150,
    //   margin: EdgeInsets.all(8.0),
    //   child: Column(
    //     children: [
    //       Image.network(
    //         'https://image.tmdb.org/t/p/w200${movie.posterPath}',
    //         height: 120,
    //       ),
    //       SizedBox(height: 8),
    //       Text(
    //         movie.title,
    //         style: TextStyle(
    //           fontSize: 16,
    //           fontWeight: FontWeight.bold,
    //         ),
    //         textAlign: TextAlign.center,
    //       ),
    //     ],
    //   ),
    // );
//   }
// }

// class NewMovieCard extends StatelessWidget {
//   final NewMovie newMovie;

//   NewMovieCard(this.newMovie);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(newMovie.title),
//       subtitle: Text(newMovie.overview),
//       leading: Image.network(
//         'https://image.tmdb.org/t/p/w200${newMovie.poster_path}',
//         height: 100,
//         width: 80,
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }
