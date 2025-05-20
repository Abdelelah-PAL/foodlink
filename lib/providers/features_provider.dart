import 'package:flutter/material.dart';
import '../models/beyond_calories_article.dart';
import '../models/feature.dart';
import '../services/features_services.dart';

class FeaturesProvider with ChangeNotifier {
  static final FeaturesProvider _instance = FeaturesProvider._internal();

  factory FeaturesProvider() => _instance;

  FeaturesProvider._internal();

  List<BeyondCaloriesArticle> articles = [];
  List<Feature> cookerFeatures = [];
  List<Feature> userFeatures = [];

  final FeaturesServices _fs = FeaturesServices();
  bool isLoading = false;
  List<Map> statuses = [
    {'active_feature': false, 'premium_feature': false},
  ];
  List<Map> userTypesAppearance = [
    {'user': false, 'cooker': false},
  ];
  List<TextEditingController> featuresControllers = [
    TextEditingController(),
  ];

  Future<void> getAllFeatures() async {
    try {
      isLoading = true;
      userFeatures.clear();
      cookerFeatures.clear();
      List<Feature> fetchedFeatures = await _fs.getAllFeatures();
      int index = 0;
      for (var doc in fetchedFeatures) {
        Feature feature = Feature(
            documentId: doc.documentId,
            arImageURL: doc.arImageURL,
            enImageURL: doc.enImageURL,
            active: doc.active,
            premium: doc.premium,
            keyword: doc.keyword,
            user: doc.user,
            cooker: doc.cooker);
        featuresControllers.insert(index, TextEditingController());
        statuses.insert(index, {
          'active_feature': doc.active,
          'premium_feature': doc.premium,
        });
        userTypesAppearance.insert(index, {
          'user': doc.user,
          'cooker': doc.cooker,
        });
        featuresControllers[index].text = doc.keyword;
        if (feature.user == true) {
          userFeatures.add(feature);
        }
        if (feature.cooker == true) {
          cookerFeatures.add(feature);
        }
        index++;
      }
      notifyListeners();
      isLoading = false;
      notifyListeners();
      print(userFeatures.length);
      print(cookerFeatures.length);
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> getAllArticles() async {
    try {
      isLoading = true;
      articles.clear();
      List<BeyondCaloriesArticle> fetchedArticles = await _fs.getAllArticles();
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
