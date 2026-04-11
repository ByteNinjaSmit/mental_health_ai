class AppointmentModel {
  final String doctor;
  final String date;

  AppointmentModel({
    required this.doctor,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'doctor': doctor,
      'date': date,
    };
  }
}