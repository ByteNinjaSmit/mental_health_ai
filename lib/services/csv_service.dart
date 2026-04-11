import 'package:flutter/services.dart';
import '../models/doctor_model.dart';

class CsvService {
  Future<List<DoctorModel>> loadDoctors() async {
    final rawData = await rootBundle.loadString('assets/doctors.csv');
    List<List<dynamic>> csvData = rawData.trim().split('\n').map((line) => line.split(',')).toList();

    if (csvData.isNotEmpty) {
      // remove header
      csvData.removeAt(0);
    }

    return csvData.map((row) {
      return DoctorModel.fromCsv(row.map((e) => e.toString()).toList());
    }).toList();
  }
}