import 'dart:io';

import 'package:attandance_edit/attendance/camera_screen.dart';
import 'package:attandance_edit/ui/home_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceScreen extends StatefulWidget {
  final XFile? image;

  const AttendanceScreen({super.key, this.image});

  @override
  State<AttendanceScreen> createState() => _AttendScreenState(this.image);
}

class _AttendScreenState extends State<AttendanceScreen> {
  String strDate = "";
  String strTime = "";
  String strDateTime = "";
  String strStatus = "Attend";
  String strAddress = "";
  double dLat = 0.0;
  double dLong = 0.0;
  int dateHours = 0;
  int dateMinutes = 0;
  bool isLoading = false;
  XFile? image;
  final controllerName = TextEditingController();
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('absensipal');

  _AttendScreenState(XFile? image);

  @override
  void initState() {
    setStatusAbsen();
    setDateTime();
    handleLocationPermition();
    super.initState();
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
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ),
        ),
        title: const Text(
          "Attendance Menu",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(15, 15, 15, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Color(0xff17B8A6),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Please Capture Your Attendance",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                child: Text(
                  "Capture Your Face",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CameraScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  width: size.width,
                  height: 150,
                  child: DottedBorder(
                    radius: const Radius.circular(10),
                    borderType: BorderType.RRect,
                    color: const Color(0xff17B8A6),
                    strokeWidth: 2,
                    dashPattern: const [5, 5],
                    child: SizedBox.expand(
                      child: FittedBox(
                        child: image != null
                            ? Image.file(File(image!.path), fit: BoxFit.cover)
                            : Image.asset(
                                'assets/images/selfie.png',
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  controller: controllerName,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelText: "Your Name",
                    hintText: "Please enter your name",
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                    labelStyle:
                        const TextStyle(fontSize: 14, color: Colors.black87),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(
                          0xff17B8A6,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(
                          0xff17B8A6,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Your Location",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(
                          0xff17B8A6,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        height: 120,
                        child: TextField(
                          enabled: false,
                          maxLines: 5,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(
                                  0xff17B8A6,
                                ),
                              ),
                            ),
                            hintText: strAddress.isNotEmpty
                                ? strAddress
                                : 'Your Location',
                            hintStyle: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                        ),
                      ),
                    ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(
                        0xff17B8A6,
                      ),
                      child: InkWell(
                        splashColor: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          if (image == null || controllerName.text.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Please complete your report first',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              backgroundColor: Colors.blueGrey,
                              shape: StadiumBorder(),
                              behavior: SnackBarBehavior.floating,
                            ));
                          } else {
                            submitAbsen(strAddress,
                                controllerName.text.toString(), strStatus);
                          }
                        },
                        child: const Center(
                          child: Text(
                            "Report Now",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> handleLocationPermition() async {
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

  Future<void> getGeoLocationPosition() async {
    //ignore: deprecated_member_use
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      isLoading = false;
      getAddressFromLongLat(position);
    });
  }

  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      dLat = position.latitude;
      dLong = position.longitude;
      strAddress =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}';
    });
  }

  void setDateTime() async {
    var dateNow = DateTime.now();
    var dateFormat = DateFormat('yyyy-MM-dd');
    var dateTime = DateFormat('HH:mm:ss');
    var dateHour = DateFormat('HH');
    var dateMinute = DateFormat('mm');

    setState(() {
      strDate = dateFormat.format(dateNow);
      strTime = dateTime.format(dateNow);
      strDateTime = "$strDate | $strTime";
      dateHours = int.parse(dateHour.format(dateNow));
      dateMinutes = int.parse(dateMinute.format(dateNow));
    });
  }

  void setStatusAbsen() {
    if (dateHours < 8 || dateHours == 8 && dateMinutes <= 30) {
      strStatus = "Masuk";
    } else if ((dateHours > 8 && dateHours < 18) ||
        (dateHours == 18 && dateMinutes <= 31)) {
      strStatus = "Telat";
    } else {
      strStatus = "Absent";
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

  Future<void> submitAbsen(String address, String name, String status) async {
    showLoaderDialog(context);
    dataCollection.add({
      'address': address,
      'name': name,
      'status': status,
      'dateTime': strDateTime,
    }).then((result) {
      setState(() {
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.white),
                  Text(
                    'Absen Berhasil',
                  ),
                ],
              ),
              backgroundColor: Colors.orangeAccent,
              shape: StadiumBorder(),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Text(
                      'Ups $e',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.orangeAccent,
              shape: StadiumBorder(),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              Expanded(
                child: Text(
                  'Walah $error',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orangeAccent,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }
}
