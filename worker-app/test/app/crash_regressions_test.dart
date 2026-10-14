import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:wervexa_worker/app/providers/push_registration_provider.dart';
import 'package:wervexa_worker/app/providers/session_controller.dart';
import 'package:wervexa_worker/app/theme/app_theme.dart';
import 'package:wervexa_worker/core/localization/l10n.dart';
import 'package:wervexa_worker/domain/entities/enums.dart';
import 'package:wervexa_worker/domain/entities/verification.dart';
import 'package:wervexa_worker/domain/entities/worker.dart';
import 'package:wervexa_worker/features/onboarding/presentation/onboarding_screen.dart';
import 'package:wervexa_worker/features/verification/presentation/verification_controller.dart';
import 'package:wervexa_worker/features/verification/presentation/verification_screen.dart';
import 'package:wervexa_worker/shared/widgets/async_value_view.dart';
import 'package:wervexa_worker/shared/widgets/common_widgets.dart';

/// Crashes Crashlytics reported from the worker app, each pinned to the screen
/// that threw it.
///
/// * The notification primer put a FilledButton straight into a Row. The
///   theme gives filled buttons an infinite minimum width, which a Row cannot
///   satisfy — "BoxConstraints forces an infinite width".
/// * The service-area sheet called setSheetState after awaiting the GPS fix
///   without checking the sheet was still open. Back closes it even with
///   isDismissible off; release builds then hit a null check in setState.
/// * Sections of already-scrolling screens used ListSkeleton, itself a
///   ListView, as their loading state — "Vertical viewport was given
///   unbounded height".
void main() {
  final en = lookupAppLocalizations(AppLocale.english.locale);

  Widget app(Widget home, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.light,
        locale: AppLocale.english.locale,
        supportedLocales: AppLocale.supportedLocales,
        localizationsDelegates: appLocalizationsDelegates,
        home: home,
      ),
    );
  }

  void useTallScreen(WidgetTester tester) {
    // Tall enough that the onboarding list builds every row, primer included.
    tester.view.physicalSize = const Size(420, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  List<Override> onboarding({bool promptForNotifications = false}) => [
        sessionProvider.overrideWith(_OnboardingSession.new),
        pushRegistrationProvider.overrideWith(
          (ref) => _FakePushRegistration(ref, promptForNotifications),
        ),
      ];

  group('Onboarding', () {
    testWidgets('the notification primer lays out beside "Not now"',
        (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(app(
        const OnboardingScreen(),
        overrides: onboarding(promptForNotifications: true),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(en.notificationsTurnOn), findsOneWidget);
      expect(find.text(en.commonNotNow), findsOneWidget);
      expect(tester.getSize(find.byType(BusyFilledButton)).width,
          lessThan(420));
    });

    testWidgets('closing the service-area sheet while GPS is pending is safe',
        (tester) async {
      final geolocator = _HeldGeolocator();
      GeolocatorPlatform.instance = geolocator;
      useTallScreen(tester);

      await tester.pumpWidget(app(const OnboardingScreen(), overrides: onboarding()));
      await tester.pumpAndSettle();

      await tester.tap(find.text(en.onboardingAreaBody));
      await tester.pumpAndSettle();
      expect(find.text(en.onboardingTravelTitle), findsOneWidget);

      // Save starts the location lookup, which waits on the permission
      // answer the way a system dialog does.
      await tester.tap(find.text(en.commonSave));
      await tester.pump();

      // The worker gives up and presses back.
      await tester.binding.handlePopRoute();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text(en.onboardingTravelTitle), findsNothing);

      // Only now does the answer arrive — a refusal, so the sheet would
      // show "turn on location" if it were still open.
      geolocator.answer(LocationPermission.denied);
      await tester.pump();
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('verification renders while insurance is still loading',
      (tester) async {
    await tester.pumpWidget(app(
      const VerificationScreen(),
      overrides: [
        verificationsProvider
            .overrideWith((ref) => Stream.value(const <VerificationCase>[])),
        insurancePoliciesProvider.overrideWith(
          (ref) => Completer<List<InsurancePolicy>>().future,
        ),
      ],
    ));
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text(en.verificationInsurance), findsOneWidget);
    expect(find.byType(ListSkeleton), findsOneWidget);
  });

  testWidgets('an inline skeleton sits inside a scrolling list',
      (tester) async {
    await tester.pumpWidget(app(Scaffold(
      body: ListView(
        children: const [
          Text('Recent earnings'),
          ListSkeleton.inline(itemCount: 2, itemHeight: 90),
        ],
      ),
    )));

    expect(tester.takeException(), isNull);
    final placeholders = find.descendant(
      of: find.byType(ListSkeleton),
      matching: find.byType(Container),
    );
    expect(placeholders, findsNWidgets(2));
    expect(tester.getSize(placeholders.first).height, 90);
  });
}

class _OnboardingSession extends SessionController {
  @override
  Future<Session> build() async => const SessionOnboarding(
        worker: Worker(
          id: 'worker-1',
          firebaseUid: 'firebase-uid-ravi',
          workerCode: 'WKR-26-TEST01',
          fullName: 'Ravi Kumar',
          phone: '+919000000001',
          status: WorkerStatus.registered,
          availability: WorkerAvailability.offline,
          experienceYears: 3,
          serviceRadiusKm: 10,
          ratingCount: 0,
          jobsCompleted: 0,
          jobsCancelled: 0,
          isKycVerified: false,
          isQualificationVerified: false,
          isSkillVerified: false,
          isBackgroundVerified: false,
          isInsured: false,
        ),
        progress: OnboardingProgress(
          hasBasicProfile: true,
          hasTrade: true,
          hasSkills: true,
          hasServiceArea: false,
          hasSubmittedKyc: false,
        ),
      );
}

class _FakePushRegistration extends PushRegistration {
  _FakePushRegistration(super.ref, this._prompt);

  final bool _prompt;

  @override
  Future<bool> get needsPermissionPrompt async => _prompt;

  @override
  Future<bool> requestPermissionAndRegister() async => true;
}

/// Holds the permission check open until [answer] is called.
class _HeldGeolocator extends GeolocatorPlatform
    with MockPlatformInterfaceMixin {
  final _permission = Completer<LocationPermission>();
  LocationPermission _answer = LocationPermission.denied;

  void answer(LocationPermission permission) {
    _answer = permission;
    _permission.complete(permission);
  }

  @override
  Future<bool> isLocationServiceEnabled() async => true;

  @override
  Future<LocationPermission> checkPermission() => _permission.future;

  @override
  Future<LocationPermission> requestPermission() async => _answer;
}
