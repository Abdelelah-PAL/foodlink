import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/features_provider.dart';
import '../../../core/utils/size_config.dart';

class AutoSlider extends StatefulWidget {
  const AutoSlider({super.key});

  @override
  State<AutoSlider> createState() => _AutoSliderState();
}

class _AutoSliderState extends State<AutoSlider> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final provider = context.read<FeaturesProvider>();

      if (provider.sliderImages.isEmpty) return;

      _currentIndex =
          (_currentIndex + 1) % provider.sliderImages.length;

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeaturesProvider>(
      builder: (context, provider, _) {
        if(provider.isLoading) {
          return SizedBox(
              width: SizeConfig.getProportionalWidth(10),
              height: SizeConfig.getProportionalHeight(127),
              child: const CircularProgressIndicator());
        }
        return SizedBox(
          width: SizeConfig.getProportionalWidth(332),
          height: SizeConfig.getProportionalHeight(127),
          child: PageView.builder(
            controller: _pageController,
            itemCount: provider.sliderImages.length,
            itemBuilder: (context, index) {
              final String imageUrl = provider.sliderImages[index];

              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.error),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
