import 'package:flutter/material.dart';

class CategoriesList extends StatelessWidget {
 final String title;
  const CategoriesList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
