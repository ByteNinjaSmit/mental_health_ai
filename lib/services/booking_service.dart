import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/appointment_model.dart';

/// Doctor metadata — hardcoded for the app
class DoctorInfo {
  final String id;
  final String name;
  final String specialization;
  final String bio;
  final double rating;
  final int experience; // years
  final int fee; // INR
  final String avatarSeed;
  final List<int> availableDays; // 1=Mon ... 7=Sun

  const DoctorInfo({
    required this.id,
    required this.name,
    required this.specialization,
    required this.bio,
    required this.rating,
    required this.experience,
    required this.fee,
    required this.avatarSeed,
    required this.availableDays,
  });

  String get avatarUrl =>
      'https://api.dicebear.com/7.x/avataaars/png?seed=$avatarSeed&backgroundColor=b6e3f4';

  IconData get specialtyIcon {
    switch (specialization) {
      case 'Clinical Psychologist':
        return Icons.psychology_rounded;
      case 'Psychiatrist':
        return Icons.medical_services_rounded;
      case 'CBT Therapist':
        return Icons.self_improvement_rounded;
      case 'Counselling Psychologist':
        return Icons.people_rounded;
      case 'Child Psychologist':
        return Icons.child_care_rounded;
      case 'Neuropsychiatrist':
        return Icons.biotech_rounded;
      default:
        return Icons.local_hospital_rounded;
    }
  }
}

class BookingService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get _uid => _auth.currentUser?.uid;

  // ─── DOCTOR DATABASE ──────────────────────────────────────────────────
  static const List<DoctorInfo> doctors = [
    DoctorInfo(
      id: 'dr_sharma',
      name: 'Dr. Riya Sharma',
      specialization: 'Clinical Psychologist',
      bio: 'Specializes in anxiety disorders, depression, and behavioral therapy. 8+ years of experience working with young adults and professionals.',
      rating: 4.9,
      experience: 8,
      fee: 800,
      avatarSeed: 'RiyaSharma',
      availableDays: [1, 2, 3, 4, 5], // Mon-Fri
    ),
    DoctorInfo(
      id: 'dr_patel',
      name: 'Dr. Arjun Patel',
      specialization: 'Psychiatrist',
      bio: 'Board-certified psychiatrist with expertise in mood disorders, medication management, and comprehensive mental health evaluation.',
      rating: 4.8,
      experience: 12,
      fee: 1200,
      avatarSeed: 'ArjunPatel',
      availableDays: [1, 2, 3, 4, 5, 6], // Mon-Sat
    ),
    DoctorInfo(
      id: 'dr_singh',
      name: 'Dr. Priya Singh',
      specialization: 'CBT Therapist',
      bio: 'Expert in Cognitive Behavioral Therapy (CBT) for OCD, phobias, PTSD, and anger management. Evidence-based treatment approach.',
      rating: 4.7,
      experience: 6,
      fee: 700,
      avatarSeed: 'PriyaSingh',
      availableDays: [1, 2, 3, 5, 6], // Mon,Tue,Wed,Fri,Sat
    ),
    DoctorInfo(
      id: 'dr_mehta',
      name: 'Dr. Sneha Mehta',
      specialization: 'Counselling Psychologist',
      bio: 'Provides individual and group counselling for stress, relationship issues, grief, and personal growth. Warm and empathetic approach.',
      rating: 4.9,
      experience: 10,
      fee: 600,
      avatarSeed: 'SnehaMehta',
      availableDays: [1, 2, 3, 4, 5], // Mon-Fri
    ),
    DoctorInfo(
      id: 'dr_khan',
      name: 'Dr. Amir Khan',
      specialization: 'Child Psychologist',
      bio: 'Specializes in child and adolescent mental health, ADHD, learning disabilities, and developmental concerns. Family-oriented care.',
      rating: 4.6,
      experience: 9,
      fee: 900,
      avatarSeed: 'AmirKhan',
      availableDays: [1, 3, 4, 5, 6], // Mon,Wed,Thu,Fri,Sat
    ),
    DoctorInfo(
      id: 'dr_rao',
      name: 'Dr. Vikram Rao',
      specialization: 'Neuropsychiatrist',
      bio: 'Expert in neurological aspects of mental health including bipolar disorder, schizophrenia, and treatment-resistant conditions.',
      rating: 4.8,
      experience: 15,
      fee: 1500,
      avatarSeed: 'VikramRao',
      availableDays: [2, 3, 4, 5], // Tue-Fri
    ),
  ];

  // ─── SLOT GENERATION ─────────────────────────────────────────────────
  /// All possible time slots for a day (9 AM → 6 PM, 45-min each)
  static const List<String> _allSlots = [
    '09:00 AM - 09:45 AM',
    '09:45 AM - 10:30 AM',
    '10:30 AM - 11:15 AM',
    '11:15 AM - 12:00 PM',
    '12:00 PM - 12:45 PM',
    '12:45 PM - 01:30 PM',
    '02:00 PM - 02:45 PM',
    '02:45 PM - 03:30 PM',
    '03:30 PM - 04:15 PM',
    '04:15 PM - 05:00 PM',
    '05:00 PM - 05:45 PM',
  ];

  /// Get available slots for a doctor on a specific date.
  /// Removes already-booked slots and past-time slots for today.
  static Future<List<String>> getAvailableSlots(
    String doctorId,
    DateTime date,
  ) async {
    // 1. Get already booked slots for this doctor on this date
    final dateStr = _formatDate(date);
    final bookedSnap = await _db
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('date', isEqualTo: dateStr)
        .get();

    final bookedSlots = <String>{};
    for (var doc in bookedSnap.docs) {
      final data = doc.data();
      if (data['status'] != 'cancelled') {
        bookedSlots.add(data['timeSlot'] ?? '');
      }
    }

    // 2. Filter out booked + past-time slots
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    final available = <String>[];
    for (final slot in _allSlots) {
      if (bookedSlots.contains(slot)) continue;

      if (isToday) {
        // Parse slot start time to check if it's in the past
        final startTime = _parseSlotStartTime(slot, date);
        if (startTime != null && startTime.isBefore(now)) continue;
      }

      available.add(slot);
    }

    return available;
  }

  // ─── BOOKING TRANSACTION ──────────────────────────────────────────────
  /// Book an appointment with conflict detection.
  /// Returns the appointment ID on success, or throws on conflict.
  static Future<String> bookAppointment({
    required String doctorId,
    required String doctorName,
    required String specialization,
    required DateTime date,
    required String timeSlot,
    String? notes,
  }) async {
    if (_uid == null) throw Exception('Not authenticated');

    final dateStr = _formatDate(date);

    // Conflict check: is this slot already taken?
    final conflictCheck = await _db
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('date', isEqualTo: dateStr)
        .where('timeSlot', isEqualTo: timeSlot)
        .get();

    final hasConflict = conflictCheck.docs.any(
      (doc) => (doc.data())['status'] != 'cancelled',
    );

    if (hasConflict) {
      throw Exception('This slot is already booked. Please choose another.');
    }

    // Check if user already has a booking at the same time
    final userConflict = await _db
        .collection('appointments')
        .where('userId', isEqualTo: _uid)
        .where('date', isEqualTo: dateStr)
        .where('timeSlot', isEqualTo: timeSlot)
        .get();

    final hasUserConflict = userConflict.docs.any(
      (doc) => (doc.data())['status'] != 'cancelled',
    );

    if (hasUserConflict) {
      throw Exception('You already have an appointment at this time.');
    }

    // All clear — book it
    final docRef = await _db.collection('appointments').add({
      'userId': _uid,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctor': doctorName, // backward compat
      'specialization': specialization,
      'date': dateStr,
      'timeSlot': timeSlot,
      'status': 'booked',
      'notes': notes,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
      'timestamp': Timestamp.now(), // backward compat
    });

    return docRef.id;
  }

  // ─── LIFECYCLE MANAGEMENT ──────────────────────────────────────────────
  /// Cancel an appointment (soft delete — set status to cancelled)
  static Future<void> cancelAppointment(String appointmentId) async {
    await _db.collection('appointments').doc(appointmentId).update({
      'status': 'cancelled',
      'updatedAt': Timestamp.now(),
    });
  }

  /// Mark appointment as completed
  static Future<void> completeAppointment(String appointmentId) async {
    await _db.collection('appointments').doc(appointmentId).update({
      'status': 'completed',
      'updatedAt': Timestamp.now(),
    });
  }

  /// Reschedule: cancel old + book new
  static Future<String> rescheduleAppointment({
    required String oldAppointmentId,
    required String doctorId,
    required String doctorName,
    required String specialization,
    required DateTime newDate,
    required String newTimeSlot,
    String? notes,
  }) async {
    await cancelAppointment(oldAppointmentId);
    return bookAppointment(
      doctorId: doctorId,
      doctorName: doctorName,
      specialization: specialization,
      date: newDate,
      timeSlot: newTimeSlot,
      notes: notes,
    );
  }

  // ─── STREAMS ──────────────────────────────────────────────────────────
  /// All appointments for current user (real-time)
  static Stream<List<AppointmentModel>> getUserAppointments() {
    if (_uid == null) return const Stream.empty();
    return _db
        .collection('appointments')
        .where('userId', isEqualTo: _uid)
        .snapshots()
        .map((snap) {
      final list = snap.docs
          .map((doc) => AppointmentModel.fromFirestore(doc))
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  /// Upcoming appointments only
  static Stream<List<AppointmentModel>> getUpcomingAppointments() {
    return getUserAppointments().map(
      (all) => all.where((a) => a.isUpcoming).toList(),
    );
  }

  /// Past appointments only
  static Stream<List<AppointmentModel>> getPastAppointments() {
    return getUserAppointments().map(
      (all) => all.where((a) => a.isPast).toList(),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────
  static String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static DateTime? _parseSlotStartTime(String slot, DateTime date) {
    try {
      final startStr = slot.split(' - ')[0].trim(); // "09:00 AM"
      final parts = startStr.split(' ');
      final timeParts = parts[0].split(':');
      var hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final isPM = parts[1].toUpperCase() == 'PM';

      if (isPM && hour < 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;

      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  /// Get a doctor by ID
  static DoctorInfo? getDoctorById(String id) {
    try {
      return doctors.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Check if a date is a working day for a doctor
  static bool isDoctorAvailable(DoctorInfo doctor, DateTime date) {
    return doctor.availableDays.contains(date.weekday);
  }

  /// Generate selectable dates for next 14 days (only working days)
  static List<DateTime> getSelectableDates(DoctorInfo doctor) {
    final dates = <DateTime>[];
    final now = DateTime.now();
    for (int i = 1; i <= 21; i++) {
      final d = DateTime(now.year, now.month, now.day + i);
      if (isDoctorAvailable(doctor, d)) {
        dates.add(d);
      }
      if (dates.length >= 14) break;
    }
    return dates;
  }
}
