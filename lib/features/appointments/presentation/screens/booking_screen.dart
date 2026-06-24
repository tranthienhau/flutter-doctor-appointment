import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_chrome.dart';
import '../../../doctors/presentation/screens/doctor_list_screen.dart';

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
    final doctors = ref.watch(doctorsProvider);
    final doctor = doctors.firstWhere((d) => d['id'] == widget.doctorId);

    return Scaffold(
      appBar: const BrandAppBar(showAvatar: false, showBack: true),
      bottomNavigationBar: _ConfirmBar(
        selectedSlot: _selectedSlot,
        selectedDay: _selectedDay,
        onConfirm: _selectedSlot == null ? null : () => _confirm(doctor),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // Doctor context card.
          MedicalCard(
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(doctor['image'],
                          width: 64, height: 64, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              width: 64, height: 64, color: AppColors.surfaceContainerHigh,
                              child: const Icon(Icons.person, color: AppColors.outline))),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctor['name'],
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: AppColors.onSurface)),
                          const SizedBox(height: 2),
                          Text('${doctor['specialty']} • Heart Health Center',
                              style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.star, color: AppColors.star, size: 15),
                            const SizedBox(width: 4),
                            Text('${doctor['rating']} (${doctor['reviews']} reviews)',
                                style: const TextStyle(fontSize: 13, color: AppColors.onSurface)),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Duration / Method bento.
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'DURATION',
                  value: '45 min',
                  color: AppColors.secondary,
                  bg: AppColors.secondaryContainer.withValues(alpha: 0.25),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoTile(
                  label: 'METHOD',
                  value: 'In-person',
                  color: AppColors.primary,
                  bg: AppColors.primaryContainer.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Calendar.
          MedicalCard(
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 60)),
              focusedDay: _selectedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selected, focused) => setState(() => _selectedDay = selected),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: false,
                titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.onSurface),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(10),
                ),
                todayTextStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                selectedTextStyle: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Slots.
          MedicalCard(
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.schedule, color: AppColors.primary, size: 22),
                    SizedBox(width: 8),
                    Text('Available Slots',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.2,
                  children: _slots.map((slot) {
                    final selected = _selectedSlot == slot;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedSlot = slot),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryContainer.withValues(alpha: 0.12)
                              : AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected ? AppColors.primary : AppColors.outlineVariant,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Text(
                          slot,
                          style: TextStyle(
                            color: selected ? AppColors.primary : AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirm(Map<String, dynamic> doctor) {
    ref.read(appointmentsProvider.notifier).book({
      'doctorId': widget.doctorId,
      'name': doctor['name'],
      'specialty': doctor['specialty'],
      'image': doctor['image'],
      'fee': doctor['fee'],
      'date': _selectedDay.toIso8601String().split('T')[0],
      'slot': _selectedSlot,
      'status': 'confirmed',
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment booked successfully!'),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.go('/history');
  }
}

class _InfoTile extends StatelessWidget {
  final String label, value;
  final Color color, bg;
  const _InfoTile({required this.label, required this.value, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 11, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
        ],
      ),
    );
  }
}

class _ConfirmBar extends StatelessWidget {
  final String? selectedSlot;
  final DateTime selectedDay;
  final VoidCallback? onConfirm;
  const _ConfirmBar({required this.selectedSlot, required this.selectedDay, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Selected slot',
                    style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                Text(
                  selectedSlot == null ? 'Pick a time' : selectedSlot!,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.onSurface),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: onConfirm,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              disabledBackgroundColor: AppColors.outlineVariant,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Confirm Booking', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
