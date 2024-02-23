# Circular Carousel Slider [![pub package](https://img.shields.io/pub/v/circular_carousel_slider)](https://pub.dartlang.org/packages/circular_carousel_slider)

A Flutter package for creating a circular carousel slider.

## Usage

As simple as using any flutter Widget.

**Example:**
Add the module to your project ``pubspec.yaml``:
```yaml
...
dependencies:
 ...
 circular_carousel_slider: ^0.0.1
...
```
And install it using ``flutter pub get`` on your project folder. After that, just import the module and use it.


### Simple 

```dart
import 'package:circular_carousel_slider/circular_carousel_slider.dart';

//...
@override
Widget build(BuildContext context) {
  return CircularCarouselSlider(
    children: [],
  );
}
```

### With Controller

To control the carousel, we can use `CircularCarouselController` and pass it to the `controller` variable. Controller have some methods to control the carousel like `nextPage` and `previousPage`. Methods will not work without setting `itemsLength` variable in the controller.

```dart
import 'package:circular_carousel_slider/circular_carousel_slider.dart';

CircularCarouselController? _controller;

@override
void initState() {
  super.initState();
  _controller = CircularCarouselController(
    itemsLength: _widgetList.length,
  );
}

//...
@override
Widget build(BuildContext context) {
  return CircularCarouselSlider(
    controller: _controller,
    children: [],
  );
}

//...

ElevatedButton(
   onPressed: () => _controller?.nextPage(
     duration: const Duration(milliseconds: 300),
     curve: Curves.fastOutSlowIn,
   ),
   child: const Text('Next'),
 ),
```

### Aspect Ratio

Default aspect ratio is `1.0`. We can change it by setting `aspectRatio` variable. 

```dart
import 'package:circular_carousel_slider/circular_carousel_slider.dart';

//...
@override
Widget build(BuildContext context) {
  return CircularCarouselSlider(
    aspectRatio: 21 / 9,
    children: [],
  );
}
```

### Aspect Ratio

To get the current page index, we can use `onPageChanged` callback.

```dart
import 'package:circular_carousel_slider/circular_carousel_slider.dart';

//...
@override
Widget build(BuildContext context) {
  return CircularCarouselSlider(
    onPageChanged: (index) {
      //logic to handle page change 
    },
    children: [],
  );
}
```

<img src="images/example.gif" width="300" >

## Credits

Developed by [Damian "Damrad" Radecki](mailto:damianradecki97@gmail.com)

## Contributing

Feel free to help!