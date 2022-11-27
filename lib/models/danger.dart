import 'package:google_maps_flutter/google_maps_flutter.dart';

enum DangerLevel { low, medium, high }

class Danger {
  int id;
  String town;
  Marker marker;
  String name;

  String dangerLevel;

  Danger(
      {required this.id,
      required this.town,
      required this.marker,
      required this.dangerLevel,
        required this.name});

  factory Danger.empty() => Danger(
      id: 0,
      town: '',
      marker: Marker(
        //onTap: function,
        markerId: MarkerId('0'),
        position: LatLng(53.20127189893238, 16.39832562876689),
        infoWindow: InfoWindow(
          title: 'I am a marker',
        ),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ),
      dangerLevel: '',
  name: '');
}
