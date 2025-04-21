import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BeyondCaloriesArticlesController {
  static final BeyondCaloriesArticlesController _instance = BeyondCaloriesArticlesController._internal();
  factory BeyondCaloriesArticlesController() => _instance;
  BeyondCaloriesArticlesController._internal();

  void launchURL(BuildContext context, Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open URL')),
      );
    }
  }
}
