import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_painter_extended/image_painter_extended.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:path_provider/path_provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  Image bg = Image.asset("lib/assets/img.jpg",fit:BoxFit.cover);
  GlobalKey<ImagePainterState> painterKey=  GlobalKey<ImagePainterState>();
  
  //To use buttons
  double scale = 1;
  double translateX = 0;
  double translateY = 0;
  String savepath = "";

  bool buttonCOntrol = false;
  //TO use modes
  bool isDrawmode = true;
  PainterController _controller;
   @override
  void initState() {
    super.initState();
    _controller = _newController();
  }

  PainterController _newController() {
    PainterController controller = new PainterController();
    controller.backgroundImage = bg;
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child:new Center(child:  AspectRatio(
                  aspectRatio: 1.0, child: 
                  ImagePainter( _controller,key: painterKey,))),
          ),
          Text(savepath),
          Expanded(
            child:SingleChildScrollView(
              child:Column(
                children:[
                   Text("How to control"),
                  howTOControl(),
                  Text("Draw options"),
                  basicOptions(),
                  //To use different modes
                !buttonCOntrol?  Text("Modes") : Container(),
                 !buttonCOntrol?  switchOption() : Container(),
                //To Control with Buttons
                 buttonCOntrol?  Text("Control buttons") : Container(),
                 buttonCOntrol? optionsBUtton() : Container(),
                ]
              )
            )
          ),
         
        ],
      )
    );
  }

    Widget howTOControl(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Button mode"),
        FlutterSwitch(
                      value:  buttonCOntrol,
                      onToggle: (val) {
                        setState(() {
                           buttonCOntrol = val;
                           isDrawmode = true;
                        });
                        _controller.drawMode = true;
                        translateX =0;
                        translateY =0;
                        scale = 1;transformMatrix();
                      },
                    ),
      ],
    );
  }

  Widget switchOption(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Transform mode"),
        FlutterSwitch(
                      value:  isDrawmode,
                      inactiveColor: Colors.green,
                      onToggle: (val) {
                        setState(() {
                           isDrawmode = val;
                        });
                        _controller.drawMode = val;
                        painterKey.currentState.setState(() { });
                      },
                    ),
        Text("Draw mode"),
      ],
    );
  }

  Widget basicOptions(){
    return Wrap(
      spacing:10,
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: (){
               
                _controller.undo();
              },
              child: Text("undo")
            ),
            ElevatedButton(
              onPressed: (){
              
                _controller.redo();
              },
              child: Text("Redo")
            ),
             ElevatedButton(
              onPressed: () async {
              final String path = (await getApplicationDocumentsDirectory()).path;
              setState(() {
                savepath = "Saved to " + path;
              });
              
              print(path);
              //Save path only
              Uint8List img= await _controller.getPathBytes();
              File('$path/image1.png').writeAsBytes(img);
              },
              child: Text("save path")
            ),
            ElevatedButton(
              onPressed: () async {
             final String path = (await getApplicationDocumentsDirectory()).path;
              setState(() {
                savepath = "Saved to " + path;
              });

                translateX =0;
                translateY =0;
                scale = 1;transformMatrix();
              await Future.delayed(Duration(milliseconds: 100), () {});


              print(path);
              //save full image             
            Uint8List pngBytes = await _controller.getPNGBytes();
            File('$path/image2.png').writeAsBytes(pngBytes);

              },
              child: Text("save img")
            ),
             ElevatedButton(
              onPressed: (){
                _controller.clear();
              },
              child: Text("clear")
            ),

          ],
        );
  }

  Widget optionsBUtton(){
    return Column(
      children: [
                
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             ElevatedButton(
              onPressed: (){
                 if( scale < 2.5){
                 scale += 0.5;transformMatrix();
               }
              },
              child: Text("+")
            ),
             ElevatedButton(
              onPressed: (){
               if( scale > 1){
                 scale -= 0.5;transformMatrix();
               }
              },
              child: Text("-")
            ),
            ElevatedButton(
              onPressed: (){
                translateX =0;
                translateY =0;
                scale = 1;transformMatrix();
              },
              child: Text("reset transform")
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: (){             
                 translateY += 2;transformMatrix();              
              },
              child: Text("up")
            ),
             ElevatedButton(
              onPressed: (){               
                 translateY -= 2;transformMatrix();              
              },
              child: Text("down")
            ),
             ElevatedButton(
              onPressed: (){                              
                 translateX -= 2;transformMatrix();              
              },
              child: Text("left")
            ),
            ElevatedButton(
              onPressed: (){
                
                 translateX += 2;transformMatrix();
               
              },
              child: Text("right")
            )
          ],
        ),
      ],
    );
  }

  void transformMatrix(){
    _controller.interactionController.value = Matrix4(
              scale,0,0,0,
              0,scale,0,0,
              0,0,1,0,
              translateX,translateY,0,1,
          );
      painterKey.currentState.setState(() { });
  }

}