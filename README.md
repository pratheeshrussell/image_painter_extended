# image painter extended

This is a Flutter package that allows user to draw over images. This is an extension of the painter2 package with option to zoom and draw.

## Features

The widget supports:
- Changing fore- and background color
- Setting an image as background
- Changing the thickness of path you draw
- Exporting your painting as png
- Undo/Redo drawing a path
- Clear the whole drawing
- Zoom and pan the image

## Installation

In your `pubspec.yaml` file within your Flutter Project:

```yaml
dependencies:
  image_painter_extended: any
```

Then import it:

```dart
import 'package:image_painter_extended/image_painter_extended.dart';
```

## Use it

In order to use this plugin, first create a controller and optionally a key:

```dart
GlobalKey<ImagePainterState> painterKey =  GlobalKey<ImagePainterState>();
PainterController controller = PainterController();
controller.thickness = 5.0; // Set thickness of your brush. Defaults to 1.0
controller.backgroundColor = Colors.green; // Background color is ignores if you set a background image
controller.backgroundImage = Image.network(...); // Sets a background image. You can load images as you would normally do: From an asset, from the network, from memory...
```

That controller will handle all properties of your drawing space.  
The key will be used to refresh state of the widget, in case you decide to programmatically pan and zoom the image.  

Then, to display the painting area, create an inline `ImagePainter` widget and give it a reference to your previously created controller:

```dart
ImagePainter(controller,key: painterKey,)
```

By exporting the painting as PNG, you will get an Uint8List object which represents the bytes of the png final file:

```dart
await controller.getPNGBytes();
```

you can also get the path alone, without the image using the getPathBytes() function

The library does not handle saving the final image by itself.