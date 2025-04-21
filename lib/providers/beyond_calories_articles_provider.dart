import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/beyond_calories_article.dart';
import '../services/beyond_calories_articles_services.dart';

class BeyondCaloriesArticlesProvider with ChangeNotifier {
  static final BeyondCaloriesArticlesProvider _instance = BeyondCaloriesArticlesProvider._internal();
  factory BeyondCaloriesArticlesProvider() => _instance;

  BeyondCaloriesArticlesProvider._internal();

  List<BeyondCaloriesArticle> articles = [];
  final BeyondCaloriesArticlesServices _as = BeyondCaloriesArticlesServices();
  bool isLoading = false;
  bool imageIsPicked = false;
  XFile? pickedFile;


  void getAllArticles() async {
    try {
      isLoading = true;
      articles.clear();
      List<BeyondCaloriesArticle> fetchedArticles =
      await _as.getAllArticles();
      for (var doc in fetchedArticles) {
        BeyondCaloriesArticle article = BeyondCaloriesArticle(
          documentId: doc.documentId,
          imageUrl: doc.imageUrl,
         url: doc.url,
        );
        articles.add(article);
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }


}
