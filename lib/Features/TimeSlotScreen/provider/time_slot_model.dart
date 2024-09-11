class TimeSlotModel {
  final String id;
  final String startTime;
  final String endTime;

  TimeSlotModel({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['_id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}
