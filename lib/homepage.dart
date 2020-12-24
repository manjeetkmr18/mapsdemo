import 'dart:async';
import 'package:demo/locations.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'display.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> lines = {};

  @override
  void initState() {
    super.initState();
    locs.forEach((element) {
      BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(20, 20)), element.img)
          .then((value) => pinLocationIcon = value);
    });

    lines.add(
      Polyline(
        points: [
          LatLng(30.753196, 76.612787),
          LatLng(28.637568, 77.223447),
          LatLng(30.9010, 75.8573)
        ],
        geodesic: true,
        polylineId: PolylineId("line"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        markers: _markers,
        polylines: lines,
        initialCameraPosition:
            CameraPosition(target: LatLng(28.637568, 77.223447), zoom: 5.0),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            locs.forEach((element) async {
              _markers.add(
                Marker(
                  infoWindow: InfoWindow(
                      title: element.title,
                      snippet: element.desc,
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisplayScreen(
                                title: element.title,
                                descrition: element.desc,
                              ),
                            ),
                          )),
                  markerId: MarkerId(element.title),
                  position: element.locationCords,
                  icon: await BitmapDescriptor.fromAssetImage(
                      ImageConfiguration(size: Size(20, 20)), element.img),
                ),
              );
            });
          });
        });
  }
}
