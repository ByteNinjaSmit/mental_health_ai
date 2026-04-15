import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../services/booking_service.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final DoctorInfo doctor;
  final DateTime selectedDate;
  final String selectedSlot;
  final String? rescheduleAppointmentId;

  const BookingConfirmationScreen({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedSlot,
    this.rescheduleAppointmentId,
  });

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  final TextEditingController _notesController = TextEditingController();
  bool _isBooking = false;

  Future<void> _confirmBooking() async {
    setState(() => _isBooking = true);

    try {
      if (widget.rescheduleAppointmentId != null) {
        await BookingService.rescheduleAppointment(
          oldAppointmentId: widget.rescheduleAppointmentId!,
          doctorId: widget.doctor.id,
          doctorName: widget.doctor.name,
          specialization: widget.doctor.specialization,
          newDate: widget.selectedDate,
          newTimeSlot: widget.selectedSlot,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
      } else {
        await BookingService.bookAppointment(
          doctorId: widget.doctor.id,
          doctorName: widget.doctor.name,
          specialization: widget.doctor.specialization,
          date: widget.selectedDate,
          timeSlot: widget.selectedSlot,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
      }

      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isBooking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    final isReschedule = widget.rescheduleAppointmentId != null;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
              ).animate().scale(curve: Curves.easeOutBack),
              const SizedBox(height: 20),
              Text(
                isReschedule ? 'Rescheduled!' : 'Booking Confirmed!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your session with ${widget.doctor.name} is scheduled for ${DateFormat('EEEE, MMM d').format(widget.selectedDate)} at ${widget.selectedSlot.split(' - ')[0]}.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, height: 1.5, fontSize: 14),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Pop all the way back to appointments
                    Navigator.of(context).popUntil((route) => route.isFirst || route.settings.name == '/appointments');
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Back to Bookings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isReschedule = widget.rescheduleAppointmentId != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(isReschedule ? 'Confirm Reschedule' : 'Confirm Booking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  // Doctor
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.shade100,
                        backgroundImage: NetworkImage(widget.doctor.avatarUrl),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.doctor.name,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
                            const SizedBox(height: 4),
                            Text(widget.doctor.specialization,
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Date
                  _InfoRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: DateFormat('EEEE, MMMM d, y').format(widget.selectedDate),
                    color: const Color(0xFF5C6BC0),
                  ),
                  const SizedBox(height: 16),

                  // Time
                  _InfoRow(
                    icon: Icons.access_time_rounded,
                    label: 'Time Slot',
                    value: widget.selectedSlot,
                    color: const Color(0xFF26A69A),
                  ),
                  const SizedBox(height: 16),

                  // Duration
                  _InfoRow(
                    icon: Icons.timer_outlined,
                    label: 'Duration',
                    value: '45 minutes',
                    color: const Color(0xFFFFA726),
                  ),
                  const SizedBox(height: 16),

                  // Fee
                  _InfoRow(
                    icon: Icons.currency_rupee_rounded,
                    label: 'Consultation Fee',
                    value: '₹${widget.doctor.fee}',
                    color: const Color(0xFFEF5350),
                  ),
                ],
              ),
            ).animate().fade().slideY(begin: 0.1),

            const SizedBox(height: 24),

            // Notes
            const Text(
              'Notes (Optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Any specific concerns or information for the doctor...',
                alignLabelWithHint: true,
              ),
            ).animate().fade(delay: 150.ms),

            const SizedBox(height: 16),

            // Payment disclaimer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFA726).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFFA726).withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Color(0xFFFFA726), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Payment will be collected at the clinic. Free cancellation up to 2 hours before the appointment.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.4),
                    ),
                  ),
                ],
              ),
            ).animate().fade(delay: 200.ms),

            const SizedBox(height: 32),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isBooking ? null : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isBooking
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Text(
                        isReschedule ? 'Confirm Reschedule' : 'Confirm Booking',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                      ),
              ),
            ).animate().fade(delay: 250.ms).slideY(begin: 0.1),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
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
