class DoctorModel {
  final String name;
  final String city;
  final String specialization;
  final String phone;
  final String address;

  DoctorModel({
    required this.name,
    required this.city,
    required this.specialization,
    required this.phone,
    required this.address,
  });

  factory DoctorModel.fromCsv(List<String> row) {
    return DoctorModel(
      name: row[0],
      city: row[1],
      specialization: row[2],
      phone: row[3],
      address: row[4],
    );
  }
}