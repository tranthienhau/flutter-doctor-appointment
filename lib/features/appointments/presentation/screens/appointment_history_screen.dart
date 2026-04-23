import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'booking_screen.dart';

class AppointmentHistoryScreen extends ConsumerWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: appointments.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No appointments yet', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (_, i) {
                final appt = appointments[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(Icons.medical_services, color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Text('Doctor #${appt['doctorId']}'),
                    subtitle: Text('${appt['date']} at ${appt['slot']}'),
                    trailing: Chip(
                      label: Text(appt['status']),
                      backgroundColor: Colors.green[100],
                      labelStyle: const TextStyle(color: Colors.green),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
