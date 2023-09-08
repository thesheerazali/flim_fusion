import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_fusion/utils/genre_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final detailData = Get.arguments;
    final genreModel = GenreData().mapGenreIdsToNames(detailData.genreIds,4);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              child: CachedNetworkImage(
                imageUrl:
                    'https://image.tmdb.org/t/p/w200${detailData.posterPath}',
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                filterQuality: FilterQuality.high,
                height: Get.height * .5,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Get.height * .5),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * .08),
                  child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        detailData.title.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 30,

                          //  fontWeight: FontWeight.w700
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            extractYearFromDate(
                              detailData.releaseDate.toString(),
                            ),
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 4,
                            width: 4,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            genreModel,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RatingBar.builder(
                        initialRating: detailData.voteAverage /
                            2, // Divide by 2 to convert to a 5-star rating
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20,
                        unratedColor: Colors.white.withOpacity(0.8),
                        itemBuilder: (context, _) => const Icon(Icons.star,
                            color: Color.fromRGBO(242, 163, 58, 1)),
                        onRatingUpdate: (newRating) {
                          // Handle rating updates if needed
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ReadMoreText(
                        detailData.overview,
                        trimLines: 7,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 18),
                        colorClickableText: Colors.white,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '...Show more',
                        trimExpandedText: ' show less',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    // Build the detail screen for trending movies
  }

  String extractYearFromDate(String? releaseDate) {
    if (releaseDate != null && releaseDate.isNotEmpty) {
      try {
        final date = DateTime.parse(releaseDate);
        return date.year.toString();
      } catch (e) {
        print('Error parsing release date: $e');
      }
    }
    return '';
  }
}

// class LatestMovieDetailScreen extends StatelessWidget {
//   final Latest latestMovie; // Replace with your latest movie model
//   final String genreModel;

//   const LatestMovieDetailScreen(
//       {super.key, required this.latestMovie, required this.genreModel});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30)),
//               child: CachedNetworkImage(
//                 imageUrl:
//                     'https://image.tmdb.org/t/p/w200${latestMovie.posterPath}',
//                 placeholder: (context, url) =>
//                     const Center(child: CircularProgressIndicator()),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//                 filterQuality: FilterQuality.high,
//                 height: Get.height * .5,
//                 width: double.infinity,
//                 fit: BoxFit.fill,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () => Get.back(),
//                     child: Container(
//                         padding: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.4),
//                           borderRadius: BorderRadius.circular(50),
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 2,
//                           ),
//                         ),
//                         child: const Icon(
//                           Icons.arrow_back,
//                           color: Colors.white,
//                         )),
//                   ),
//                   Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.4),
//                         borderRadius: BorderRadius.circular(50),
//                         border: Border.all(
//                           color: Colors.white,
//                           width: 2,
//                         ),
//                       ),
//                       child: const Icon(
//                         Icons.menu,
//                         color: Colors.white,
//                       )),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: Get.height * .5),
//               child: Container(
//                 decoration: const BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20))),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: Get.width * .08),
//                   child: SingleChildScrollView(
//                     child: Column(mainAxisSize: MainAxisSize.min, children: [
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         textAlign: TextAlign.center,
//                         latestMovie.title.toUpperCase(),
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.8),
//                           fontSize: 30,

//                           //  fontWeight: FontWeight.w700
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               extractYearFromDate(
//                                 latestMovie.releaseDate.toString(),
//                               ),
//                               style: TextStyle(
//                                   color: Colors.white.withOpacity(0.8)),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             Container(
//                               height: 4,
//                               width: 4,
//                               color: Colors.white,
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             Text(
//                               genreModel,
//                               style: TextStyle(
//                                   color: Colors.white.withOpacity(0.8)),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       RatingBar.builder(
//                         initialRating: latestMovie.voteAverage /
//                             2, // Divide by 2 to convert to a 5-star rating
//                         minRating: 1,
//                         direction: Axis.horizontal,
//                         allowHalfRating: true,
//                         itemCount: 5,
//                         itemSize: 20,
//                         unratedColor: Colors.white.withOpacity(0.8),
//                         itemBuilder: (context, _) => const Icon(Icons.star,
//                             color: Color.fromRGBO(242, 163, 58, 1)),
//                         onRatingUpdate: (newRating) {
//                           // Handle rating updates if needed
//                         },
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       ReadMoreText(
//                         latestMovie.overview,
//                         trimLines: 7,
//                         style: TextStyle(
//                             color: Colors.white.withOpacity(0.8), fontSize: 18),
//                         colorClickableText: Colors.white,
//                         trimMode: TrimMode.Line,
//                         trimCollapsedText: '...Show more',
//                         trimExpandedText: ' show less',
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                     ]),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//     // Build the detail screen for latest movies
//   }

//   String extractYearFromDate(String? releaseDate) {
//     if (releaseDate != null && releaseDate.isNotEmpty) {
//       try {
//         final date = DateTime.parse(releaseDate);
//         return date.year.toString();
//       } catch (e) {
//         print('Error parsing release date: $e');
//       }
//     }
//     return '';
//   }
// }
