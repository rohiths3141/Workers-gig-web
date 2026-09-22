import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/active_booking/active_booking_screen.dart';
import '../../features/assistant/assistant_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/auth/phone_entry_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/bookings/booking_detail_screen.dart';
import '../../features/bookings/bookings_screen.dart';
import '../../features/categories/service_category_screen.dart';
import '../../features/explore/explore_screen.dart';
import '../../features/gig_discovery/book_service_screen.dart';
import '../../features/gig_discovery/gig_details_screen.dart';
import '../../features/gig_discovery/gig_discovery_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/location_picker/location_picker_screen.dart';
import '../../features/materials/materials_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/payments/payment_screen.dart';
import '../../features/profile/addresses_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/reviews/review_screen.dart';
import '../../features/reviews/service_completed_screen.dart';
import '../../features/service_request/service_request_screen.dart';
import '../../features/service_requests/my_service_requests_screen.dart';
import '../../features/service_requests/offers_received_screen.dart';
import '../../features/service_requests/post_service_request_screen.dart';
import '../../features/service_requests/service_request_detail_screen.dart';
import '../../features/shell/app_shell.dart';
import '../../features/shell/config_error_screen.dart';
import '../../features/shell/session_error_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/support/support_screen.dart';
import '../../features/support/support_ticket_screen.dart';
import '../providers/session_controller.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouterProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionProvider);

  return GoRouter(
    navigatorKey: _rootKey,
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    redirect: (context, state) {
      final location = state.matchedLocation;

      // ── Guard: routes that REQUIRE state.extra ──
      // GoRouter restores the route stack after process death, but
      // state.extra is a non-serialisable Dart object and comes back null.
      // Redirect to /home rather than crashing the render tree.
      const _extraRequiredRoutes = ['/gig-discovery', '/auth/otp', '/book-service'];
      final needsExtra = _extraRequiredRoutes.contains(location) ||
          location.startsWith('/gigs/');
      if (needsExtra && state.extra == null) {
        return '/home';
      }

      // Still loading — stay on splash
      if (session.isLoading || session.value is SessionLoading) {
        return location == '/splash' ? null : '/splash';
      }

      final currentSession = session.value;
      final isAuthRoute = location.startsWith('/auth');
      final isSplash = location == '/splash';

      return switch (currentSession) {
        null || SessionLoading() =>
          location == '/splash' ? null : '/splash',
        SessionConfigurationError() =>
          location == '/config-error' ? null : '/config-error',
        SessionSignedOut() =>
          // Signed out → go to login; but if already on auth flow, stay.
          isAuthRoute ? null : '/auth/phone',
        SessionError() =>
          // DB/network/clock error after auth. Bouncing to the phone screen
          // looked like a silent sign-out and cost the customer another OTP;
          // show what happened with a retry instead.
          location == '/session-error' ? null : '/session-error',
        SessionNeedsRegistration() =>
          location == '/auth/register' ? null : '/auth/register',
        SessionReady() =>
          isAuthRoute || isSplash ? '/home' : null,
      };
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/config-error',
        builder: (_, __) => const ConfigErrorScreen(),
      ),
      GoRoute(
        path: '/session-error',
        builder: (_, __) => const SessionErrorScreen(),
      ),

      // Auth flow
      GoRoute(
        path: '/auth/phone',
        builder: (_, __) => const PhoneEntryScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) context.go('/auth/phone');
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return OtpScreen(
            verificationId: extra['verificationId'] as String,
            phoneNumber: extra['phoneNumber'] as String,
            resendToken: extra['resendToken'] as int?,
          );
        },
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) {
          final session = ref.read(sessionProvider).value;
          return RegisterScreen(
            firebaseUid: session is SessionNeedsRegistration
                ? session.firebaseUid
                : '',
            phoneNumber: session is SessionNeedsRegistration
                ? session.phoneNumber
                : null,
          );
        },
      ),

      // Shell — main app with bottom nav
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/explore',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ExploreScreen(),
            ),
          ),
          GoRoute(
            path: '/bookings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BookingsScreen(),
            ),
          ),
          GoRoute(
            path: '/notifications',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NotificationsScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Full-screen routes (above shell)
      GoRoute(
        path: '/assistant',
        builder: (_, __) => const AssistantScreen(),
      ),
      GoRoute(
        path: '/services/:serviceId',
        builder: (context, state) => ServiceCategoryScreen(
          serviceId: state.pathParameters['serviceId']!,
          serviceName: state.uri.queryParameters['name'] ?? '',
        ),
      ),
      GoRoute(
        path: '/location-picker',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return LocationPickerScreen(initial: extra);
        },
      ),
      GoRoute(
        path: '/service-request/:serviceId',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ServiceRequestScreen(
            serviceId: state.pathParameters['serviceId']!,
            serviceName: state.uri.queryParameters['name'] ?? '',
            prefilledLocation: extra,
          );
        },
      ),
      GoRoute(
        path: '/gig-discovery',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            // state.extra is not serialisable — after process death GoRouter
            // restores the path but extra is null. Redirect home.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) context.go('/home');
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return GigDiscoveryScreen(request: extra);
        },
      ),
      GoRoute(
        path: '/gigs/:gigId',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) context.go('/home');
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return GigDetailsScreen(gigCard: extra);
        },
      ),
      GoRoute(
        path: '/book-service',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) context.go('/home');
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return BookServiceScreen(gigCard: extra);
        },
      ),
      GoRoute(
        path: '/bookings/:bookingId',
        builder: (context, state) => BookingDetailScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/bookings/:bookingId/active',
        builder: (context, state) => ActiveBookingScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/bookings/:bookingId/materials',
        builder: (context, state) => MaterialsScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/bookings/:bookingId/review',
        builder: (context, state) => ReviewScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/bookings/:bookingId/completed',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ServiceCompletedScreen(
            serviceName: extra?['serviceName'] as String? ?? 'Service',
            workerName: extra?['workerName'] as String?,
            amountLabel: extra?['amountLabel'] as String?,
          );
        },
      ),
      GoRoute(
        path: '/bookings/:bookingId/payment',
        builder: (context, state) => PaymentScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/addresses',
        builder: (_, __) => const AddressesScreen(),
      ),
      GoRoute(
        path: '/profile/support',
        builder: (_, __) => const SupportScreen(),
      ),

      // Service Requests (Model B)
      GoRoute(
        path: '/post-request',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PostServiceRequestScreen(
            preselectedCategoryId: extra?['category_id'] as String?,
            preselectedCategoryName: extra?['category_name'] as String?,
            prefilledLocation: extra?['location'] as Map<String, dynamic>?,
            // Set by the assistant, which has already collected the problem
            // in the customer's own words.
            prefilledTitle: extra?['title'] as String?,
            prefilledDescription: extra?['description'] as String?,
          );
        },
      ),
      GoRoute(
        path: '/my-requests',
        builder: (_, __) => const MyServiceRequestsScreen(),
      ),
      GoRoute(
        path: '/my-requests/:requestId',
        builder: (context, state) => ServiceRequestDetailScreen(
          requestId: state.pathParameters['requestId']!,
        ),
      ),
      GoRoute(
        path: '/my-requests/:requestId/offers',
        builder: (context, state) => OffersReceivedScreen(
          requestId: state.pathParameters['requestId']!,
        ),
      ),
      GoRoute(
        path: '/profile/support/:ticketId',
        builder: (context, state) => SupportTicketScreen(
          ticketId: state.pathParameters['ticketId']!,
          subject: state.extra as String?,
        ),
      ),
    ],
  );
});
