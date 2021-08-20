import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class MapsUI extends StatefulWidget {
  final String lat;
  final String long;

  const MapsUI({Key key, this.lat, this.long}) : super(key: key);

  @override
  _MapsUIState createState() => _MapsUIState();
}

class _MapsUIState extends State<MapsUI> {
  Position userLocation;

  @override
  void initState() {
    super.initState();
    // _getLocation().then((position) {
    // userLocation;
    // });
  }

  // Future<Position> _getLocation() async {
  //   var currentLocation;
  //   try {
  //     currentLocation = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.best);
  //   } catch (e) {
  //     currentLocation = null;
  //   }
  //   return currentLocation;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(double.parse(widget.lat), double.parse(widget.long)),
            zoom: 15.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 60.0,
                  height: 60.0,
                  point: LatLng(
                      double.parse(widget.lat), double.parse(widget.long)),
                  builder: (ctx) => Container(
                    child: Image(
                      image: AssetImage('assets/marker.png'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
