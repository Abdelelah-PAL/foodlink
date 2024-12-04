import 'package:flutter/material.dart';
import 'package:foodlink/models/beyond_calories_article.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({super.key, required this.article});

  final BeyondCaloriesArticle article;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async => await launchUrl(Uri.parse(article.url)),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            child: Image.network(
              article.imageUrl,
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    );
  }
}
