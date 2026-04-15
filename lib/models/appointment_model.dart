import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String userId;
  final String doctorId;
  final String doctorName;
  final String specialization;
  final String date; // "2026-04-20"
  final String timeSlot; // "10:00 AM - 10:45 AM"
  final String status; // booked | completed | cancelled
  final String? notes;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.date,
    required this.timeSlot,
    required this.status,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      doctorId: data['doctorId'] ?? '',
      doctorName: data['doctorName'] ?? data['doctor'] ?? '',
      specialization: data['specialization'] ?? '',
      date: data['date'] ?? '',
      timeSlot: data['timeSlot'] ?? '',
      status: data['status'] ?? 'booked',
      notes: data['notes'],
      createdAt: data['createdAt'] ?? data['timestamp'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialization': specialization,
      'date': date,
      'timeSlot': timeSlot,
      'status': status,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'timestamp': createdAt, // backward compat
    };
  }

  /// Parse date string "2026-04-20" into DateTime
  DateTime get dateTime {
    try {
      return DateTime.parse(date);
    } catch (_) {
      return DateTime.now();
    }
  }

  bool get isUpcoming =>
      status == 'booked' &&
      dateTime.isAfter(DateTime.now().subtract(const Duration(hours: 1)));

  bool get isPast =>
      status == 'completed' ||
      status == 'cancelled' ||
      dateTime.isBefore(DateTime.now().subtract(const Duration(hours: 1)));

  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';
  bool get isBooked => status == 'booked';
}