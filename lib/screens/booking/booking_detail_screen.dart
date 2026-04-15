import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../models/appointment_model.dart';
import '../../services/booking_service.dart';
import 'slot_picker_screen.dart';

class BookingDetailScreen extends StatelessWidget {
  final AppointmentModel appointment;

  const BookingDetailScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final doctor = BookingService.getDoctorById(appointment.doctorId);
    final statusColor = _getStatusColor(appointment.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Booking Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [statusColor.withValues(alpha: 0.15), statusColor.withValues(alpha: 0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(_getStatusIcon(appointment.status), color: statusColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getStatusTitle(appointment.status),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: statusColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusSubtitle(appointment),
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fade().slideY(begin: -0.1),

            const SizedBox(height: 24),

            // Doctor Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Doctor', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.grey.shade100,
                        backgroundImage: doctor != null ? NetworkImage(doctor.avatarUrl) : null,
                        child: doctor == null ? const Icon(Icons.person) : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appointment.doctorName,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
                            const SizedBox(height: 4),
                            Text(appointment.specialization.isNotEmpty ? appointment.specialization : 'Mental Health Professional',
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      if (doctor != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.orange, size: 14),
                              const SizedBox(width: 2),
                              Text('${doctor.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ).animate().fade(delay: 100.ms).slideY(begin: 0.05),

            const SizedBox(height: 16),

            // Appointment Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Appointment Info', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 16),
                  _DetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: _formatDisplayDate(appointment.date),
                    color: const Color(0xFF5C6BC0),
                  ),
                  const SizedBox(height: 14),
                  _DetailRow(
                    icon: Icons.access_time_rounded,
                    label: 'Time Slot',
                    value: appointment.timeSlot.isNotEmpty ? appointment.timeSlot : 'N/A',
                    color: const Color(0xFF26A69A),
                  ),
                  const SizedBox(height: 14),
                  _DetailRow(
                    icon: Icons.timer_outlined,
                    label: 'Duration',
                    value: '45 minutes',
                    color: const Color(0xFFFFA726),
                  ),
                  if (doctor != null) ...[
                    const SizedBox(height: 14),
                    _DetailRow(
                      icon: Icons.currency_rupee_rounded,
                      label: 'Fee',
                      value: '₹${doctor.fee}',
                      color: const Color(0xFFEF5350),
                    ),
                  ],
                ],
              ),
            ).animate().fade(delay: 150.ms).slideY(begin: 0.05),

            // Notes
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Notes', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
                    const SizedBox(height: 10),
                    Text(appointment.notes!, style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5)),
                  ],
                ),
              ).animate().fade(delay: 200.ms),
            ],

            // Booked on
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Booked on ${DateFormat('MMM d, y · h:mm a').format(appointment.createdAt.toDate())}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons (only for upcoming booked appointments)
            if (appointment.isUpcoming && appointment.isBooked) ...[
              // Reschedule
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (doctor == null) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SlotPickerScreen(
                          doctor: doctor,
                          rescheduleAppointmentId: appointment.id,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_calendar_rounded),
                  label: const Text('Reschedule'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Cancel
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => _showCancelDialog(context),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancel Appointment'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Appointment?'),
        content: const Text('Are you sure you want to cancel this booking? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () async {
              await BookingService.cancelAppointment(appointment.id);
              if (context.mounted) {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Appointment cancelled'), backgroundColor: Colors.redAccent),
                );
              }
            },
            child: const Text('Cancel Booking', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDisplayDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('EEEE, MMMM d, y').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'booked':
        return const Color(0xFF0077B6);
      case 'completed':
        return const Color(0xFF26A69A);
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'booked':
        return Icons.event_available_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _getStatusTitle(String status) {
    switch (status) {
      case 'booked':
        return 'Upcoming Session';
      case 'completed':
        return 'Session Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  String _getStatusSubtitle(AppointmentModel appt) {
    switch (appt.status) {
      case 'booked':
        return 'Your appointment is confirmed';
      case 'completed':
        return 'This session has been completed';
      case 'cancelled':
        return 'This appointment was cancelled';
      default:
        return '';
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF03045E))),
            ],
          ),
        ),
      ],
    );
  }
}
