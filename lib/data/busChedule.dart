import 'package:travels_displayboard/data/bus_schedule.dart';

class BusChedule {

  List<BusSchedule> busSchedule;

	BusChedule.fromJsonMap(Map<String, dynamic> map): 
		busSchedule = List<BusSchedule>.from(map["busSchedule"].map((it) => BusSchedule.fromJsonMap(it)));

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['busSchedule'] = busSchedule != null ? 
			this.busSchedule.map((v) => v.toJson()).toList()
			: null;
		return data;
	}
}
