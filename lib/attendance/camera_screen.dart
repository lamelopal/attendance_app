import 'dart:io';
import 'package:attandance_edit/attendance/attendance_screen.dart';
import 'package:attandance_edit/utils/face_detection/google_ml_kit.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  FaceDetector faceDetector =
      GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
    enableTracking: true,
    enableLandmarks: true,
  ));

  List<CameraDescription>? cameras;
  CameraController? controller;
  bool isBusy = false;
  bool isCameraOn = true; // Track camera state
  XFile? image;

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Function to toggle camera
  void toggleCamera() async {
    if (controller != null) {
      if (isCameraOn) {
        await controller!.dispose();
        setState(() {
          isCameraOn = false;
        });
      } else {
        loadCamera();
        setState(() {
          isCameraOn = true;
        });
      }
    }
  }

  loadCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        final frontCamera = cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras!.first,
        );

        controller = CameraController(
          frontCamera,
          ResolutionPreset.veryHigh,
          enableAudio: false,
        );

        await controller!.initialize();

        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print("Camera error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error initializing camera'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xff17B8A6),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: const Text(
          'Capture a selfie image',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            width: size.width,
            height: size.height * 0.6,
            padding: const EdgeInsets.only(top: 0),
            child: isCameraOn &&
                    controller != null &&
                    controller!.value.isInitialized
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Transform.scale(
                      scale: 1.0,
                      filterQuality: FilterQuality.high,
                      child: AspectRatio(
                        aspectRatio: controller!.value.aspectRatio,
                        child: CameraPreview(controller!),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_off,
                            size: 64,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Please turn on your camera',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: size.width,
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: const Text(
                    'Make sure your face is clearly visible',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tombol Toggle Camera
                      ClipOval(
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            splashColor: Colors.blueAccent,
                            onTap: toggleCamera,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: const Color(0xff17B8A6),
                                ),
                              ),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(
                                  isCameraOn ? Icons.folder_off : Icons.camera,
                                  color: const Color(0xff17B8A6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Tombol Capture
                      if (isCameraOn) // Hanya tampilkan jika kamera menyala
                        ClipOval(
                          child: Material(
                            color: Colors.blueAccent,
                            child: InkWell(
                              splashColor: Colors.blue,
                              onTap: () async {
                                final hasPermission =
                                    await handleLocationPermition(context);
                                try {
                                  if (controller != null) {
                                    if (controller!.value.isInitialized) {
                                      controller!.setFlashMode(FlashMode.off);
                                      image = await controller!.takePicture();
                                      setState(() {
                                        if (hasPermission) {
                                          showLoaderDialog(context);
                                          final inputImage =
                                              InputImage.fromFilePath(
                                                  image!.path);
                                          Platform.isAndroid
                                              ? prosesCamera(inputImage)
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AttendanceScreen(
                                                            image: image),
                                                  ),
                                                );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_off,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'Please enable location service',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                              backgroundColor: Colors.blueGrey,
                                              shape: StadiumBorder(),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      });
                                    }
                                  }
                                } catch (e) {
                                  print("Error taking picture: $e");
                                }
                              },
                              child: const SizedBox(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future<bool> handleLocationPermition(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.location_off,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Please enable location service',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          backgroundColor: Colors.blueGrey,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.location_off,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Please enable location service',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          backgroundColor: Colors.blueGrey,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> prosesCamera(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    isBusy = false;

    if (mounted) {
      setState(() {
        Navigator.of(context).pop(true);
        if (faces.length > 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AttendanceScreen(
                image: image,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.face_retouching_natural_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      'Face not detected',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.blueGrey,
              shape: StadiumBorder(),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
          ),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text("Checking..."),
          ),
        ],
      ),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
