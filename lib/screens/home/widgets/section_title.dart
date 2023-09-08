import 'package:film_fusion/screens/home/catagories/latest_categories_.dart';
import 'package:film_fusion/screens/home/catagories/trending_category.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => title == "New Movies"
          ? LatestCategoriesList(
              title,
            )
          : TrendingCategoriesList(
              title,
            )),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }
}

// class TrendingSectionTitle extends StatelessWidget {
//   final String title;
//   final dynamic trendingCatageryData;

//   const TrendingSectionTitle({
//     super.key,
//     required this.title,
//     required this.trendingCatageryData,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Get.to(TrendingCategoriesList(title, trendingCatageryData)),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.white.withOpacity(0.6),
//         ),
//       ),
//     );
//   }
// }
