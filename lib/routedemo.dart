import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String GoogleApiKEY = "AIzaSyDxuCF5Ie4nH7YtCaKNOhwMCBATEhjuJBs";

class RoutesDemo extends StatefulWidget {
  @override
  _RoutesDemoState createState() => _RoutesDemoState();
}

class _RoutesDemoState extends State<RoutesDemo> {
  CameraPosition _initialCamera = CameraPosition(
    target: LatLng(30.753196, 76.612787),
    zoom: 14.0000,
  );
  Completer<GoogleMapController> _mapController = Completer();
  final Set<Marker> _markers = Set();

  final LatLng sourceLatLong = LatLng(30.753196, 76.612787);
  final LatLng destinationLatLong = LatLng(32.045798, 76.659883);
  final Set<Polyline> _polyline = {};
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _markers.add(Marker(
        markerId: MarkerId("1"),
        position: sourceLatLong,
        infoWindow: InfoWindow(
          title: "source: Kharar",
        ),
        icon: BitmapDescriptor.defaultMarker,
        visible: true));

    _markers.add(Marker(
        markerId: MarkerId("2"),
        position: destinationLatLong,
        infoWindow: InfoWindow(
          title: "destination: BAijnath",
        ),
        icon: BitmapDescriptor.defaultMarker,
        visible: true));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: GoogleMap(
        mapType: MapType.normal,
        polylines: _polyline,
        myLocationEnabled: true,
        onCameraIdle: () {
          print('camera stop');
        },
        initialCameraPosition: _initialCamera,
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
          _getPoliLine();
        },
        markers: _markers,
      ),
    );
  }

  Future<dynamic> _getPoliLine() {
    final JsonDecoder _decoder = JsonDecoder();

    final BASE_URL = "https://maps.googleapis.com/maps/api/directions/json?" +
        "origin=" +
        sourceLatLong.latitude.toString() +
        "," +
        sourceLatLong.longitude.toString() +
        "&destination=" +
        destinationLatLong.latitude.toString() +
        "," +
        destinationLatLong.longitude.toString() +
        "&key=$GoogleApiKEY";

    print(BASE_URL);
    return http.get(BASE_URL).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(res);
      }

      try {
        String _distance = _decoder
                .convert(res)["routes"][0]["legs"][0]["distance"]['text']
                .toString() ??
            'No Dispaly';
        _scaffoldkey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Distance: $_distance',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )));
      } catch (e) {
        throw new Exception(res);
      }

      List<Steps> steps;
      try {
        steps =
            parseSteps(_decoder.convert(res)["routes"][0]["legs"][0]["steps"]);

        List<LatLng> _listOfLatLongs = [];

        for (final i in steps) {
          _listOfLatLongs.add(i.startLocation);
          _listOfLatLongs.add(i.endLocation);
        }

        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _polyline.add(Polyline(
              polylineId: PolylineId("2"),
              visible: true,
              width: 8,
              points: _listOfLatLongs,
              color: Colors.blue,
            ));
          });
        });
      } catch (e) {
        throw new Exception(res);
      }

      return steps;
    });
  }

  List<Steps> parseSteps(final responseBody) {
    var list =
        responseBody.map<Steps>((json) => new Steps.fromJson(json)).toList();
    return list;
  }
}

class Steps {
  LatLng startLocation;
  LatLng endLocation;
  Steps({this.startLocation, this.endLocation});
  factory Steps.fromJson(Map<String, dynamic> json) {
    return new Steps(
        startLocation: new LatLng(
            json["start_location"]["lat"], json["start_location"]["lng"]),
        endLocation: new LatLng(
            json["end_location"]["lat"], json["end_location"]["lng"]));
  }
}
