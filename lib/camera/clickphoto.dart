import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {

   TakePictureScreen({
    Key? key
  }) : super(key: key);

  late final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late final XFile image;
  bool pictaken=false;
  bool cameraready=false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) =>
    {
    setState(() {
    camerafunc();
    }),


    });


  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }
   void camerafunc() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
setState(() {
  widget.camera= firstCamera;
  _controller = CameraController(

    // Get a specific camera from the list of available cameras.
    widget.camera,
    // Define the resolution to use.
    ResolutionPreset.medium,

  );

  // Next, initialize the controller. This returns a Future.
  _initializeControllerFuture = _controller.initialize();
  cameraready=true;

});

  }

  @override
  Widget build(BuildContext context) {
    return Stack(children:[SafeArea(child: Center(child:FutureBuilder<void>(
        future: cameraready?_initializeControllerFuture:null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return !pictaken?CameraPreview(_controller):Image.file(File(image.path));
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),),),
       Positioned( bottom: 10,right:10,child:
       FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            image = await _controller.takePicture();
            setState(()  {

              pictaken=true;
            });


            // If the picture was taken, display it on a new screen.

          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
       ),
    ],

    );
  }
}
