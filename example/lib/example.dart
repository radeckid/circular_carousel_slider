import 'package:circular_carousel_slider/circular_carousel_controller.dart';
import 'package:circular_carousel_slider/circular_carousel_slider.dart';
import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int _selectedIndex = 0;

  final List<Widget> _widgetList = const [
    ExampleItem(
      color: Colors.red,
      index: 1,
    ),
    ExampleItem(
      color: Colors.green,
      index: 2,
    ),
    ExampleItem(
      color: Colors.blue,
      index: 3,
    ),
  ];

  CircularCarouselController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = CircularCarouselController(
      itemsLength: _widgetList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircularCarouselSlider(
            controller: _controller,
            onPageChanged: (index) => setState(() => _selectedIndex = index),
            aspectRatio: 21 / 9,
            children: _widgetList,
          ),
          Text(
            _selectedIndex.toString(),
            style: const TextStyle(
              fontSize: 24.0,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                ),
                onPressed: () => _controller?.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                ),
                child: const Text('Previous'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () => _controller?.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                ),
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExampleItem extends StatelessWidget {
  final Color color;
  final int index;

  const ExampleItem({
    super.key,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          index.toString(),
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
