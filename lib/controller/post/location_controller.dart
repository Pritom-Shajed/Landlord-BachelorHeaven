import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class LocationController extends GetxController {
  RxList<dynamic> placeList = [].obs;

  getLocationSuggestion(String input, String sessionToken) async {
    String apiKey = 'AIzaSyDFQ4Tytf_adWN-_oAXDLGE2AYIVBM5fZc';
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseUrl?input=$input&key=$apiKey&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));
    print(response.body);
    try {
      if (response.statusCode == 200) {
        placeList.value = jsonDecode(response.body.toString())['predictions'];
      } else {
        throw Exception('Erro Occured');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
