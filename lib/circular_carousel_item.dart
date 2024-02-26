part of 'circular_carousel_slider.dart';

class _CircularCarouselItem {
  late double x;
  late double y;
  late double z;
  late double angle;
  final int index;
  final Widget widget;

  _CircularCarouselItem(this.index, this.widget)
      : x = 0,
        y = 0,
        z = 0,
        angle = 0;
}
