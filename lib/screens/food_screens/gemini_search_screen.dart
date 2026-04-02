import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../models/meal.dart';
import '../../providers/settings_provider.dart';
import '../../services/gemini_service.dart';
import '../../services/translation_services.dart';
import '../widgets/custom_app_iconic_textfield.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_text.dart';
import 'meal_screen.dart';
import 'widgets/themealdb_tile.dart';

class GeminiSearchScreen extends StatefulWidget {
  const GeminiSearchScreen({super.key});

  @override
  State<GeminiSearchScreen> createState() => _GeminiSearchScreenState();
}

class _GeminiSearchScreenState extends State<GeminiSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GeminiService _apiService = GeminiService();
  List<Meal> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  void _generate() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _searchResults = [];
    });

    try {
      final results = await _apiService.generateMealsFromIngredients(_searchController.text.trim());
      setState(() {
        _searchResults = results;
        if (results.isEmpty) {
          _error = 'no_meals_found';
        }
      });
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      setState(() {
        _error = errorMessage;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onMealTap(Meal meal) {
    Get.to(() => MealScreen(meal: meal, source: 'ai_generated'));
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.getProperVerticalSpace(7)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getProportionalWidth(50),
                horizontal: SizeConfig.getProportionalWidth(20)),
            child:  Stack(
              alignment: Alignment.center,
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child:  CustomBackButton()),
                 const Center(
                  child: CustomText(
                      isCenter: true,
                      text: "AI Meal Gen",
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.network_check, color: AppColors.widgetsColor),
                    onPressed: () async {
                      bool success = await _apiService.testConnection();
                      if (success) {
                        Get.snackbar("Success", "Backend is reachable!",
                            backgroundColor: Colors.green, colorText: Colors.white);
                      } else {
                        Get.snackbar("Error", "Cannot reach backend. Check 10.0.2.2:3500",
                            backgroundColor: Colors.red, colorText: Colors.white);
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CustomAppIconicTextField(
              width: 348,
              height: 45,
              headerText: "enter_ingredients_comma",
              icon: Assets.mealIngredients,
              controller: _searchController,
              maxLines: 1,
              iconSizeFactor: 28,
              iconPadding: 26,
              settingsProvider: settingsProvider,
              enabled: !_isLoading,
              fontSize: 16,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.widgetsColor,
                  minimumSize: Size(SizeConfig.screenWidth! * 0.9, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const CustomText(
                      text: "search",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      isCenter: true,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading && _searchResults.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.widgetsColor),
                        SizedBox(height: 16),
                        Text("Chef Gemini is thinking..."),
                      ],
                    )
                  : _error != null
                      ? Center(child: CustomText(text: TranslationService().translate(_error!), fontSize: 10, isCenter: true, fontWeight: FontWeight.normal))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final meal = _searchResults[index];
                            return TheMealDBTile(
                              meal: meal,
                              onTap: () => _onMealTap(meal),
                              settingsProvider: settingsProvider,
                              isLoading: false,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
