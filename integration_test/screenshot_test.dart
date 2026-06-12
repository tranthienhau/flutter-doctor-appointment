import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_doctor_appointment/main.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> shoot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await tester.pump(const Duration(milliseconds: 400));
    await binding.takeScreenshot(name);
  }

  testWidgets('capture doctor appointment flow', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pump(const Duration(milliseconds: 600));

    // 01 - Doctor listing
    await shoot(tester, '01-doctor-list');

    // Tap the first doctor card -> detail screen.
    final card = find.text('Dr. Sarah Chen');
    await tester.ensureVisible(card);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(card, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 700));
    await shoot(tester, '02-doctor-detail');

    // Tap Book Appointment -> calendar booking screen.
    final book = find.text('Book Appointment');
    await tester.ensureVisible(book);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(book, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 700));
    await shoot(tester, '03-booking-calendar');

    // Select a time slot to populate the booking state.
    final slot = find.text('10:00 AM');
    await tester.ensureVisible(slot);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(slot, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 400));
    await shoot(tester, '04-slot-selected');

    // Confirm booking -> navigates to appointment history with a real record.
    final confirm = find.text('Confirm Booking');
    await tester.ensureVisible(confirm);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(confirm, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 900));
    await shoot(tester, '05-appointment-history');
  });
}
