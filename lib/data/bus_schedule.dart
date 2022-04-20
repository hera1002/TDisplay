
class BusSchedule {

  String service;
  String route;
  String time;
  String vehicle;
  String status;
  String via;
  String distance;

	BusSchedule.fromJsonMap(Map<String, dynamic> map): 
		service = map["service"],
		route = map["route"],
		time = map["time"],
		vehicle = map["vehicle"],
		status = map["status"],
		via = map["via"],
		distance = map["distance"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['service'] = service;
		data['route'] = route;
		data['time'] = time;
		data['vehicle'] = vehicle;
		data['status'] = status;
		data['via'] = via;
		data['distance'] = distance;
		return data;
	}
}
