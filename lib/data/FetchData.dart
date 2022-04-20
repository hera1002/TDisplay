import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:travels_displayboard/data/Response.dart';
import 'package:travels_displayboard/data/busChedule.dart';
import 'package:travels_displayboard/data/bus_schedule.dart';

class DataProvider{

  Future<http.Response> fetchSchedule() {
    return http.get(Uri.parse('http://10.0.2.2:3000/users'));
  }

  Future<List<BusSchedule>> getData()  async {
    http.Response  response= await fetchSchedule();
    print(jsonDecode(response.body)["busSChedule"]);
    print("999");
    BusChedule tt =BusChedule.fromJsonMap(jsonDecode(response.body));
    print(tt.busSchedule[0].route);
    return BusChedule.fromJsonMap(jsonDecode(response.body)).busSchedule;
  }

}
