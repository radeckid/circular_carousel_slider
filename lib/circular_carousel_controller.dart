library circular_carousel_slider;

import 'package:flutter/material.dart';

class CircularCarouselController extends ChangeNotifier {
  Curve? animationCurve;
  Duration? animationDuration;
  int currentPage = 0;
  bool _disposed = false;
  int itemsLength;

  CircularCarouselController({
    this.itemsLength = 0,
  });

  void nextPage({
    Duration? duration,
    Curve? curve,
  }) {
    if (itemsLength < 1) return;
    animationDuration = duration;
    animationCurve = curve;
    currentPage++;
    if (currentPage >= itemsLength) {
      currentPage = 0;
    }
    notifyListeners();
  }

  void previousPage({
    Duration? duration,
    Curve? curve,
  }) {
    if (itemsLength < 1) return;
    animationDuration = duration;
    animationCurve = curve;
    currentPage--;
    if (currentPage < 0) {
      currentPage = itemsLength - 1;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
