import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyHome extends StatefulWidget {
  MyHome({Key key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<Marker> allMarkers = [];
  GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    allMarkers.add(
      Marker(
        markerId: MarkerId('my marker'),
        draggable: true,
        position: LatLng(32.045798, 76.659883),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            onMapCreated: mapCreated,
            initialCameraPosition:
                CameraPosition(target: LatLng(32.045798, 76.659883), zoom: 9.0),
            markers: Set.from(allMarkers),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.movie_rounded),
        onPressed: movetoNewYork(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  movetoChd() {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(28.637568, 77.223447),
          zoom: 9.0,
        ),
      ),
    );
  }

  movetoNewYork() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 12.0),
    ));
  }
}
