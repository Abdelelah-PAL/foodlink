import 'package:flutter/cupertino.dart';
import '../models/user_details.dart';

class GeneralProvider with ChangeNotifier {
  static final GeneralProvider _instance = GeneralProvider._internal();
  factory GeneralProvider() => _instance;

  GeneralProvider._internal();
  String language = 'ar';
}