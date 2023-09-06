// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_fusion/screens/home/detailScreen/detail_screen.dart';
import 'package:flutter/material.dart';

import 'package:film_fusion/controller/home_screen_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class LatestMoviePoster extends GetView<HomeScreenController> {
  LatestMoviePoster({
    Key? key,
  }) : super(key: key);

  final genreData = {
    "genres": [
      {"id": 28, "name": "Action"},
      {"id": 12, "name": "Adventure"},
      {"id": 16, "name": "Animation"},
      {"id": 35, "name": "Comedy"},
      {"id": 80, "name": "Crime"},
      {"id": 99, "name": "Documentary"},
      {"id": 18, "name": "Drama"},
      {"id": 10751, "name": "Family"},
      {"id": 14, "name": "Fantasy"},
      {"id": 36, "name": "History"},
      {"id": 27, "name": "Horror"},
      {"id": 10402, "name": "Music"},
      {"id": 9648, "name": "Mystery"},
      {"id": 10749, "name": "Romance"},
      {"id": 878, "name": "Science Fiction"},
      {"id": 10770, "name": "TV Movie"},
      {"id": 53, "name": "Thriller"},
      {"id": 10752, "name": "War"},
      {"id": 37, "name": "Western"}
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: SizedBox(
          height: 200,
          child: Obx(
            () => ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 20,
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: controller.latestMovies.length,
              itemBuilder: (context, index) {
                final movie = controller.latestMovies[index];
                final genreNames = mapGenreIdsToNames(movie.genreIds);
                return GestureDetector(
                  onTap: () => Get.to(LatestMovieDetailScreen(
                    latestMovie: movie,
                    genreModel: genreNames,
                  )),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(50),
                    ),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.fill,
                      width: 147,
                      height: 217,
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }

  String mapGenreIdsToNames(List<int>? genreIds) {
    if (genreIds == null || genreIds.isEmpty) {
      return 'Unknown';
    }

    final genreNames = genreIds
        .map((genreId) {
          final genre = genreData['genres']?.firstWhere(
            (genre) => genre['id'] == genreId,
            orElse: () => {'name': 'Unknown'},
          );
          return genre?['name'] ?? 'Unknown';
        })
        .take(4)
        .toList();

    return genreNames.join('-');
  }
}
