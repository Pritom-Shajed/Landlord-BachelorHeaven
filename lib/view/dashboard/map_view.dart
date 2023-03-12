import 'dart:async';
import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/widgets/mapMarker.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ApartmentMapView extends StatelessWidget {
  String lat;
  String lon;
  String title;
  ApartmentMapView({Key? key, required this.lat, required this.lon, required this.title}) : super(key: key);

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(title, style: poppinsTextStyle(color: blackColor),),
    ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            double.parse(lat),
            double.parse(lon),
          ),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          mapMarker(
              lat: double.parse(lat),
              lon: double.parse(lon),
              infoTitle: title),
        },
      ),
    );
  }
}
