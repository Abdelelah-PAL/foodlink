import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:foodlink/models/slider_image.dart';
import '../models/beyond_calories_article.dart';
import '../models/feature.dart';

class FeaturesServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;

  Future<List<Feature>> getAllFeatures() async {
    try {
      QuerySnapshot<Map<String, dynamic>> featureQuery =
          await _firebaseFireStore.collection('features').get();

      List<Feature> features = featureQuery.docs.map((doc) {
        return Feature.fromJson(doc.data(), doc.id);
      }).toList();
      return features;
    } catch (ex) {
      rethrow;
    }
  }

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

  Future<List<SliderImage>> getActiveImages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('slider_images')
          .where('active', isEqualTo: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => SliderImage.fromJson(
          doc.data(),
          doc.id, // pass docId if your model supports it
        ),
      )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

}


