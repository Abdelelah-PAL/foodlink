import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/beyond_calories_article.dart';

class BeyondCaloriesArticlesServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;


  Future<List<BeyondCaloriesArticle>> getAllArticles() async {
    try {
      QuerySnapshot<Map<String, dynamic>> articleQuery =
          await _firebaseFireStore.collection('beyond_calories_articles').get();

      List<BeyondCaloriesArticle> articles = articleQuery.docs.map((doc) {
        return BeyondCaloriesArticle.fromJson(doc.data(), doc.id);
      }).toList();

      return articles;
    } catch (ex) {
      rethrow;
    }
  }
}
