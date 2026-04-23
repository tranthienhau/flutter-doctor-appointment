import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/doctors/presentation/screens/doctor_list_screen.dart';
import 'features/doctors/presentation/screens/doctor_detail_screen.dart';
import 'features/appointments/presentation/screens/booking_screen.dart';
import 'features/appointments/presentation/screens/appointment_history_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const DoctorListScreen()),
    GoRoute(path: '/doctor/:id', builder: (_, state) => DoctorDetailScreen(doctorId: state.pathParameters['id']!)),
    GoRoute(path: '/book/:id', builder: (_, state) => BookingScreen(doctorId: state.pathParameters['id']!)),
    GoRoute(path: '/history', builder: (_, __) => const AppointmentHistoryScreen()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DocBook',
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
