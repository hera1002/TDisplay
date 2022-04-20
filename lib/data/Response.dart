import 'package:travels_displayboard/data/bus_schedule.dart';

class Response {

  final List<BusSchedule> busScheduleList;

	Response.fromJsonMap(Map<String, dynamic> map): 
		busScheduleList = List<BusSchedule>.from(
				map["busSchedule"].map((it) {
					print(it);
					BusSchedule.fromJsonMap(it);
				}
				)
		);

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['busSchedule'] = busScheduleList != null ? 
			this.busScheduleList.map((v) => v.toJson()).toList()
			: null;
		return data;
	}
}
