import 'package:film_fusion/model/new_movies_model.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Latest movies;
  const DetailScreen({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movies.title),
      ),
    );
  }
}
