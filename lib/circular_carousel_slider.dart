library circular_carousel_slider;

import 'dart:math';

import 'package:circular_carousel_slider/circular_carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

part 'circular_carousel_item.dart';

class CircularCarouselSlider extends StatefulWidget {
  final double aspectRatio;
  final List<Widget> children;
  final CircularCarouselController? controller;
  final Function(int index)? onPageChanged;

  const CircularCarouselSlider({
    super.key,
    this.aspectRatio = 1.0,
    this.children = const [],
    this.controller,
    this.onPageChanged,
  });

  @override
  State<CircularCarouselSlider> createState() => _CircularCarouselSliderState();
}

class _CircularCarouselSliderState extends State<CircularCarouselSlider>
    with TickerProviderStateMixin {
  AnimationController? _frontCardCtrl;
  AnimationController? _frictionCtrl;

  List<_CircularCarouselItem> itemsList = [];
  double radius = 0.0;

  double angleStep = 0;

  double _dragX = 0;
  double _velocityX = 0;
  double frontAngle = 0;
  double angleOffset = 0;

  @override
  void initState() {
    super.initState();

    itemsList = widget.children
        .asMap()
        .map((key, value) => MapEntry(key, _CircularCarouselItem(key, value)))
        .values
        .toList();
    angleStep = -(pi * 2) / widget.children.length;

    _frontCardCtrl?.dispose();
    _frontCardCtrl = AnimationController.unbounded(vsync: this);
    _frontCardCtrl?.addListener(() => setState(() {}));

    _frictionCtrl?.dispose();
    _frictionCtrl = AnimationController.unbounded(vsync: this);
    _frictionCtrl?.addListener(() => setState(() {}));

    final _CircularCarouselItem maxZ = itemsList.reduce(
      (curr, next) => curr.z > next.z ? curr : next,
    );
    _frontCardAnimation(
      widget.controller?.currentPage ?? maxZ.index,
      duration: const Duration(milliseconds: 350),
    );
    widget.controller?.addListener(() {
      final int? currentPage = widget.controller?.currentPage;
      if (currentPage != null) {
        _frontCardAnimation(
          currentPage,
          duration: widget.controller?.animationDuration,
          curve: widget.controller?.animationCurve,
        );
      }
    });
    widget.controller?.removeListener(() {});
  }

  @override
  void dispose() {
    _frontCardCtrl?.dispose();
    _frictionCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _calculateRadiusAndAngles();
    _positionCardsInCircle();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        _frictionCtrl?.stop();
        _frontCardCtrl?.stop();
      },
      onPanUpdate: (dragDetails) {
        _dragX += dragDetails.delta.dx;
        setState(() {});
      },
      onPanEnd: (dragDetails) {
        _velocityX = dragDetails.velocity.pixelsPerSecond.dx;
        _frictionAnimation();
      },
      child: Stack(
        alignment: Alignment.center,
        children: _generateCards(),
      ),
    );
  }

  Widget addCard(_CircularCarouselItem cardData) {
    final double cardAlpha = 0.75 + 0.25 * cardData.z / radius;
    return Opacity(
      opacity: cardAlpha,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: cardData.widget,
      ),
    );
  }

  void _frictionAnimation() {
    _dragX = 0;
    _frontCardCtrl?.value = 0;

    final double beginAngle = angleOffset - pi / 2;

    final FrictionSimulation simulate =
        FrictionSimulation(.00001, beginAngle, -_velocityX * .006);
    _frictionCtrl?.animateWith(simulate).whenComplete(() {
      // re-center the front card
      final _CircularCarouselItem maxZ = itemsList.reduce(
        (curr, next) => curr.z > next.z ? curr : next,
      );
      _frontCardAnimation(maxZ.index);
    });
  }

  void _frontCardAnimation(
    int index, {
    Duration? duration,
    VoidCallback? whenComplete,
    Curve? curve,
  }) {
    _dragX = 0;
    _frictionCtrl?.value = 0;

    frontAngle = -index * angleStep;

    double beginAngle = angleOffset - pi / 2;
    // because one point can be expressed by multiple different angles in a trigonometric circle
    // we need to find the closest to the front angle.
    if (beginAngle < frontAngle) {
      while ((frontAngle - beginAngle).abs() > pi) {
        beginAngle += pi * 2;
      }
    } else {
      while ((frontAngle - beginAngle).abs() > pi) {
        beginAngle -= pi * 2;
      }
    }

    // animate the front card to the front angle
    _frontCardCtrl?.value = beginAngle;
    _frontCardCtrl
        ?.animateTo(
      frontAngle,
      duration: duration ?? const Duration(milliseconds: 150),
      curve: curve ?? Curves.linear,
    )
        .whenComplete(
      () {
        whenComplete?.call();
        widget.controller?.currentPage = index;
        widget.onPageChanged?.call(index);
      },
    );
  }

  void _calculateRadiusAndAngles() {
    radius = MediaQuery.of(context).size.shortestSide * 0.4;
    angleOffset = pi / 2 + (-_dragX * .006);
    angleOffset += _frictionCtrl?.value ?? 0;
    angleOffset += _frontCardCtrl?.value ?? 0;
  }

  void _positionCardsInCircle() {
    // positioning cards in a circle
    for (var i = 0; i < itemsList.length; ++i) {
      final _CircularCarouselItem cardData = itemsList[i];
      final double ang = angleOffset + cardData.index * angleStep;
      cardData.angle = ang;
      cardData.x = cos(ang) * radius;
      // to move the cards up or down, we can set the y value to sin(ang) * radius.
      cardData.y = 0;
      cardData.z = sin(ang) * radius;
    }

    // sort in Z axis.
    itemsList.sort((a, b) => a.z.compareTo(b.z));
  }

  List<Widget> _generateCards() => itemsList.map((cardData) {
        final Widget card = addCard(cardData);
        final Matrix4 matrix = Matrix4.identity();
        matrix.setEntry(3, 2, 0.001);

        // position the card based on x,y,z
        matrix.translate(cardData.x, cardData.y, -cardData.z);

        // scale the card based on z position
        double scale = 1 + (cardData.z / radius) * 0.5;
        scale = scale.clamp(0.8, 0.8);
        matrix.scale(scale);

        return Transform(
          alignment: Alignment.center,
          origin: Offset.zero,
          transform: matrix,
          child: card,
        );
      }).toList();
}
