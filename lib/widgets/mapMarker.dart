import 'package:google_maps_flutter/google_maps_flutter.dart';


Marker mapMarker({required double lat, required double lon, required String infoTitle}){
 return Marker(
      markerId: MarkerId('Apartment Location'),
      position: LatLng(lat, lon),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: infoTitle));
}
