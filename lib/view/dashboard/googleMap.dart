import 'dart:async';
import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapGoogle extends StatefulWidget {
  MapGoogle({Key? key}) : super(key: key);

  @override
  State<MapGoogle> createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Position? position;

  final Set<Marker> markers = {};

  addMarker() {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId('Current-Location'),
        position: LatLng(position!.latitude, position!.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: 'Location')
      ));
    });
  }

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position2 = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      position = position2;
    });
  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: position != null
          ? GoogleMap(
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  position!.latitude,
                  position!.longitude,
                ),
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                addMarker();
                _controller.complete(controller);
              },
        markers: markers,
            )
          : Center(
              child: CircularProgressIndicator(color: blackColor,),
            ),
    );
  }
}
