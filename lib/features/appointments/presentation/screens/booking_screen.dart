import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

final appointmentsProvider = StateNotifierProvider<AppointmentNotifier, List<Map<String, dynamic>>>(
  (ref) => AppointmentNotifier(),
);

class AppointmentNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  AppointmentNotifier() : super([]);

  void book(Map<String, dynamic> appointment) {
    state = [...state, appointment];
  }
}

class BookingScreen extends ConsumerStatefulWidget {
  final String doctorId;
  const BookingScreen({super.key, required this.doctorId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime _selectedDay = DateTime.now();
  String? _selectedSlot;

  final _slots = ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM', '04:00 PM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 60)),
              focusedDay: _selectedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selected, focused) => setState(() => _selectedDay = selected),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Available Slots', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _slots.map((slot) {
              final selected = _selectedSlot == slot;
              return ChoiceChip(
                label: Text(slot),
                selected: selected,
                onSelected: (_) => setState(() => _selectedSlot = slot),
                selectedColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(color: selected ? Colors.white : null),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _selectedSlot == null ? null : () {
              ref.read(appointmentsProvider.notifier).book({
                'doctorId': widget.doctorId,
                'date': _selectedDay.toIso8601String().split('T')[0],
                'slot': _selectedSlot,
                'status': 'confirmed',
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment booked successfully!'), backgroundColor: Colors.green),
              );
              context.go('/history');
            },
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }
}
