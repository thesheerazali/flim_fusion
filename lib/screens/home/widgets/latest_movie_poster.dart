// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_fusion/screens/home/detailScreen/detail_screen.dart';
import 'package:flutter/material.dart';

import 'package:film_fusion/controller/home_screen_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class LatestMoviePoster extends StatelessWidget {
  final HomeScreenController controller;

  const LatestMoviePoster({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: SizedBox(
        height: 200,
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 20,
            );
          },
          scrollDirection: Axis.horizontal,
          itemCount: controller.latestMovies.length,
          itemBuilder: (context, index) {
            final movie = controller.latestMovies[index];
            return GestureDetector(
              onTap: () => Get.to( DetailScreen(movies: movie,)),
              child: Card(
                elevation: 5,
                child: SizedBox(
                  width: 147,
                  height: 217,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
