import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:project_mobile/page/home_screen.dart';
import 'package:project_mobile/screens/mobile_screen.dart';
import 'package:project_mobile/utils/colors.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  // Location ตู้เติมน้ำ
  final LatLng _MahidolU = LatLng(13.7943405, 100.3257339);
  final LatLng _ICT_f2_1stAidRoom = LatLng(13.7948003, 100.3246630);
  final LatLng _library_f1_coWorking = LatLng(13.7946961, 100.3241450);
  final LatLng _library_f1_eLecture = LatLng(13.7941767, 100.3241340);
  final LatLng _LA_building = LatLng(13.796983, 100.321034);
  final LatLng _MLC_711 = LatLng(13.794092, 100.321213);

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    // mark ที่ ICT ชั้น 2 หน้าห้องพยาบาล
    _markers.add(
      Marker(
        markerId: MarkerId("ICT 2nd floor First aid room"),
        position: _ICT_f2_1stAidRoom,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(
                      16), // เพิ่ม border radius ที่คุณต้องการ
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 204, 204, 204),
                      offset: const Offset(0, 1),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10.0), // ทำให้รูปขอบโค้ง
                        child: Image(
                          image: NetworkImage(
                              'https://drive.google.com/uc?view&id=1l9coLSimSFPIVUIqDVyGQN8iHRPGbWKx'),
                        ),
                      ),
                      SizedBox(height: 16), // Add some spacing
                      Text(
                        "ตึกคณะ ICT ม.มหิดล",
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 54, 84, 134)),
                      ),
                      SizedBox(height: 2), // Add some spacing
                      Text(
                        "ชั้น 2 หน้าห้องพยาบาล",
                        style:
                            TextStyle(color: Color.fromARGB(255, 54, 84, 134)),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _ICT_f2_1stAidRoom,
          );
        },
      ),
    );

    // mark ที่ ห้องสมุดชั้น1 โซน co working space
    _markers.add(
      Marker(
        markerId: MarkerId("library Co-Working Space"),
        position: _library_f1_coWorking,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(
                      16), // เพิ่ม border radius ที่คุณต้องการ
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 204, 204, 204),
                      offset: const Offset(0, 1),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10.0), // ทำให้รูปขอบโค้ง
                        child: Image(
                          image: NetworkImage(
                              'https://drive.google.com/uc?view&id=1FsymJP1VpM3bu50PEmtyOXqZEY_5Llha'),
                        ),
                      ),
                      SizedBox(height: 8), // Add some spacing
                      Text(
                        "หอสมุดและคลังความรู้ (MU)",
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 54, 84, 134)),
                      ),
                      SizedBox(height: 4), // Add some spacing
                      Text(
                        "ชั้น 1 โซน Co-Working Space ใกล้กับห้องละหมาด",
                        style:
                            TextStyle(color: Color.fromARGB(255, 54, 84, 134)),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _library_f1_coWorking,
          );
        },
      ),
    );

    // mark ที่ ห้องสมุดชั้น1 โซน e-lecture
    _markers.add(
      Marker(
        markerId: MarkerId("library E-Lecture"),
        position: _library_f1_eLecture,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(
                      16), // เพิ่ม border radius ที่คุณต้องการ
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 204, 204, 204),
                      offset: const Offset(0, 1),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10.0), // ทำให้รูปขอบโค้ง
                        child: Image(
                          image: NetworkImage(
                              'https://drive.google.com/uc?view&id=1ktm7AqfW3uW5WcMJTSBMm4JDSeNPP60O'),
                        ),
                      ),
                      SizedBox(height: 8), // Add some spacing
                      Text(
                        "หอสมุดและคลังความรู้ (MU)",
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 54, 84, 134)),
                      ),
                      SizedBox(height: 4), // Add some spacing
                      Text(
                        "ชั้น 1 โซน E-Lecture",
                        style:
                            TextStyle(color: Color.fromARGB(255, 54, 84, 134)),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _library_f1_eLecture,
          );
        },
      ),
    );

    // mark ที่ตึก อาคารสิริวิทยา คณะ LA
    _markers.add(
      Marker(
        markerId: MarkerId("LA 1st floor"),
        position: _LA_building,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(
                      16), // เพิ่ม border radius ที่คุณต้องการ
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 204, 204, 204),
                      offset: const Offset(0, 1),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10.0), // ทำให้รูปขอบโค้ง
                        child: Image(
                          image: NetworkImage(
                              'https://drive.google.com/uc?view&id=1Ei5WpYTfwT9IgtQRzLxm6YxadaH_AYHw'),
                        ),
                      ),
                      SizedBox(height: 8), // Add some spacing
                      Text(
                        "อาคารสิริวิทยา คณะศิลปศาสตร์",
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 54, 84, 134)),
                      ),
                      SizedBox(height: 4), // Add some spacing
                      Text(
                        "ชั้น 1 หน้าห้องน้ำหญิง",
                        style:
                            TextStyle(color: Color.fromARGB(255, 54, 84, 134)),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _LA_building,
          );
        },
      ),
    );

    // mark ที่ mlc
    _markers.add(
      Marker(
        markerId: MarkerId("MLC 7-11"),
        position: _MLC_711,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(
                      16), // เพิ่ม border radius ที่คุณต้องการ
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 204, 204, 204),
                      offset: const Offset(0, 1),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10.0), // ทำให้รูปขอบโค้ง
                        child: Image(
                          image: NetworkImage(
                              'https://drive.google.com/uc?view&id=1fdS1wykaLS5dzm0iR15WtylwTrdO1YyW'),
                        ),
                      ),
                      SizedBox(height: 8), // Add some spacing
                      Text(
                        "ศูนย์การเรียนรู้มหิดล Mahidol Learning Center (MLC)",
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 54, 84, 134)),
                      ),
                      SizedBox(height: 4), // Add some spacing
                      Text(
                        "ที่ลานดอกกันภัย ใกล้ห้องน้ำ",
                        style:
                            TextStyle(color: Color.fromARGB(255, 54, 84, 134)),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _MLC_711,
          );
        },
      ),
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          
          GoogleMap(
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) async {
              _customInfoWindowController.googleMapController = controller;
            },
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: _MahidolU,
              zoom: 16,
            ),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 300,
            width: 200,
            offset: 50,
          ),
        ],
      ),

    );
  }
}


/* Code example from: https://pub.dev/packages/custom_info_window/example */

 //Positioned(
          //   left: 115,
          //   bottom: 25,
          //   child: Container(
          //     alignment: Alignment.center,
          //     width: 180,
          //     height: 42,
          //     child: ElevatedButton(
          //         style: ButtonStyle(
          //             backgroundColor:
          //                 MaterialStateProperty.all<Color>(thirdColor)),
          //         onPressed: () {
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (context) {
          //             return MobileScreen();
          //           }));
          //         },
          //         child: const Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Icon(
          //               Icons.arrow_back_ios_new,
          //               color: secondColor,
          //               size: 18,
          //             ),
          //             Text(
          //               'Back to home',
          //               style: TextStyle(
          //                   color: firstColor,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold),
          //             ),
                      
          //           ],
          //         )),
          //   ),
          // ),
