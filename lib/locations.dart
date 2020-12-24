import 'package:google_maps_flutter/google_maps_flutter.dart';

class Locations {
  LatLng locationCords;
  String title;
  String desc;
  String img;

  Locations({this.locationCords, this.title, this.desc, this.img});
}

final List<Locations> locs = [
  Locations(
      locationCords: LatLng(30.753196, 76.612787),
      title: 'Kharar ',
      desc: 'this is test',
      img: 'assets/icons/mapicon.png'),
  Locations(
      locationCords: LatLng(28.637568, 77.223447),
      title: 'Delhi',
      desc: 'this is test',
      img: 'assets/icons/mapic.png'),
  Locations(
      locationCords: LatLng(30.9010, 75.8573),
      title: 'Palampur',
      desc: 'this is test',
      img: 'assets/icons/marker.png'),
  Locations(
      locationCords: LatLng(32.045798, 76.659883),
      title: 'Baijnath',
      desc: 'this is test',
      img: 'assets/icons/mapih.png'),
];
