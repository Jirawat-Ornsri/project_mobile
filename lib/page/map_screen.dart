import 'dart:async';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =Completer();

  static const LatLng library1 = LatLng(13.7946111, 100.3240978);
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Map Screen'),),);
    // return Scaffold(
    //   body: GoogleMap(
    //     mapType: MapType.hybrid,
    //     initialCameraPosition: CameraPosition(
    //       target: library1, 
    //       zoom: 14.5
    //     ),
    //     markers: {
    //       Marker(
    //         markerId: MarkerId("li"),
    //         position: library1,
    //       ),
    //     },
    //   ),
    // );
  }
}