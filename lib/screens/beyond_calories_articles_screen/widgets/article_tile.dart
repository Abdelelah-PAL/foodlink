import 'package:flutter/material.dart';
import 'package:foodlink/models/beyond_calories_article.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/colors.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({super.key, required this.article});

  final BeyondCaloriesArticle article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await launchUrl(Uri.parse(article.url)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.widgetsColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11), // radius - border thickness
          child: Image.network(
            article.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
