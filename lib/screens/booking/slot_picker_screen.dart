import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../services/booking_service.dart';
import 'booking_confirmation_screen.dart';

class SlotPickerScreen extends StatefulWidget {
  final DoctorInfo doctor;
  final String? rescheduleAppointmentId;

  const SlotPickerScreen({
    super.key,
    required this.doctor,
    this.rescheduleAppointmentId,
  });

  @override
  State<SlotPickerScreen> createState() => _SlotPickerScreenState();
}

class _SlotPickerScreenState extends State<SlotPickerScreen> {
  late List<DateTime> _selectableDates;
  DateTime? _selectedDate;
  String? _selectedSlot;
  List<String> _availableSlots = [];
  bool _loadingSlots = false;

  @override
  void initState() {
    super.initState();
    _selectableDates = BookingService.getSelectableDates(widget.doctor);
    if (_selectableDates.isNotEmpty) {
      _selectedDate = _selectableDates.first;
      _loadSlots();
    }
  }

  Future<void> _loadSlots() async {
    if (_selectedDate == null) return;
    setState(() {
      _loadingSlots = true;
      _selectedSlot = null;
    });

    final slots = await BookingService.getAvailableSlots(
      widget.doctor.id,
      _selectedDate!,
    );

    if (mounted) {
      setState(() {
        _availableSlots = slots;
        _loadingSlots = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReschedule = widget.rescheduleAppointmentId != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(isReschedule ? 'Reschedule' : 'Select Date & Time'),
      ),
      body: Column(
        children: [
          // Doctor Info Strip
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: NetworkImage(widget.doctor.avatarUrl),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.doctor.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
                      Text(widget.doctor.specialization,
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF26A69A).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '₹${widget.doctor.fee}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF26A69A), fontSize: 14),
                  ),
                ),
              ],
            ),
          ).animate().fade().slideY(begin: -0.1),

          const SizedBox(height: 20),

          // Date Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                const Text('Select Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── DATE SELECTOR (horizontal scroll) ──
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _selectableDates.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final date = _selectableDates[index];
                final isSelected = _selectedDate != null &&
                    date.year == _selectedDate!.year &&
                    date.month == _selectedDate!.month &&
                    date.day == _selectedDate!.day;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedDate = date);
                    _loadSlots();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 68,
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(date),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white.withValues(alpha: 0.8) : Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : const Color(0xFF03045E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('MMM').format(date),
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? Colors.white.withValues(alpha: 0.8) : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Time Slot Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.access_time_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                const Text('Available Slots', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
                const Spacer(),
                if (!_loadingSlots)
                  Text('${_availableSlots.length} available', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── TIME SLOT GRID ──
          Expanded(
            child: _loadingSlots
                ? const Center(child: CircularProgressIndicator())
                : _availableSlots.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy_rounded, size: 56, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text('No slots available for this date.',
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text('Try selecting another date.',
                                style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3.2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _availableSlots.length,
                        itemBuilder: (context, index) {
                          final slot = _availableSlots[index];
                          final isSelected = _selectedSlot == slot;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedSlot = slot),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade200,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 3))]
                                    : [],
                              ),
                              child: Center(
                                child: Text(
                                  slot.split(' - ')[0], // show just start time
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : const Color(0xFF03045E),
                                  ),
                                ),
                              ),
                            ),
                          ).animate().fade(delay: (30 * index).ms).scale(begin: const Offset(0.95, 0.95));
                        },
                      ),
          ),

          // ── BOTTOM CTA ──
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: (_selectedDate != null && _selectedSlot != null)
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingConfirmationScreen(
                                doctor: widget.doctor,
                                selectedDate: _selectedDate!,
                                selectedSlot: _selectedSlot!,
                                rescheduleAppointmentId: widget.rescheduleAppointmentId,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    disabledBackgroundColor: Colors.grey.shade200,
                  ),
                  child: Text(
                    _selectedSlot != null ? 'Continue — $_selectedSlot' : 'Select a time slot',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
