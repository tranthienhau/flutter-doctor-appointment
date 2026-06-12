# Screenshot capture flow

Real captures from the iOS Simulator via an integration-test driver (no mockups).

## Steps

1. Boot the simulator:
   ```bash
   xcrun simctl boot "iPhone 17 Pro"
   open -a Simulator
   ```
2. Scaffold the iOS platform folder (lib-only project) and get dependencies:
   ```bash
   flutter create . --platforms=ios --project-name flutter_doctor_appointment
   flutter pub get
   ```
3. Drive the screenshot test:
   ```bash
   flutter drive \
     --driver test_driver/integration_test.dart \
     --target integration_test/screenshot_test.dart \
     -d "iPhone 17 Pro"
   ```
4. Build the demo GIF from the PNGs:
   ```bash
   cd screenshots
   ffmpeg -y -framerate 1 -pattern_type glob -i '*.png' \
     -vf "scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
     -loop 0 demo.gif
   ```

PNGs + `demo.gif` are written to `screenshots/` and embedded in `README.md`.

## How it works

- `test_driver/integration_test.dart` - `integrationDriver(onScreenshot:)` writes each PNG to `screenshots/<name>.png`.
- `integration_test/screenshot_test.dart` - pumps the real app wrapped in a `ProviderScope` (`ProviderScope(child: MyApp())`) so the Riverpod doctor and appointment providers resolve, then drives the booking flow end to end:
  1. `01-doctor-list` - the seeded doctor listing.
  2. Taps `Dr. Sarah Chen` -> `02-doctor-detail` (profile, stats, bio).
  3. Taps `Book Appointment` -> `03-booking-calendar` (TableCalendar + time slots).
  4. Taps the `10:00 AM` slot -> `04-slot-selected`.
  5. Taps `Confirm Booking` -> `05-appointment-history`, which now shows the freshly booked appointment plus the success snackbar.
- Each capture calls `binding.convertFlutterSurfaceToImage()` + `binding.takeScreenshot('NN-name')`. Navigation uses fixed `tester.pump(Duration)` waits (not `pumpAndSettle`) so route and snackbar animations do not stall the driver.
