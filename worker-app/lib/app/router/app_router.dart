import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/customer_service_request.dart';

import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/phone_entry_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/customer_requests/presentation/customer_request_detail_screen.dart';
import '../../features/customer_requests/presentation/customer_requests_screen.dart';
import '../../features/customer_requests/presentation/my_offers_screen.dart';
import '../../features/gigs/presentation/gig_editor_screen.dart';
import '../../features/gigs/presentation/my_gigs_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/jobs/presentation/active_job_screen.dart';
import '../../features/jobs/presentation/job_detail_screen.dart';
import '../../features/jobs/presentation/jobs_screen.dart';
import '../../features/jobs/presentation/travel_map_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shell/presentation/app_shell.dart';
import '../../features/shell/presentation/session_error_screen.dart';
import '../../features/shell/presentation/splash_screen.dart';
import '../../features/support/presentation/support_screen.dart';
import '../../features/support/presentation/ticket_thread_screen.dart';
import '../../features/verification/presentation/bank_account_screen.dart';
import '../../features/verification/presentation/kyc_screen.dart';
import '../../features/verification/presentation/qualification_screen.dart';
import '../../features/verification/presentation/verification_screen.dart';
import '../../features/wallet/presentation/payout_screen.dart';
import '../../features/wallet/presentation/transactions_screen.dart';
import '../../features/wallet/presentation/wallet_screen.dart';
import '../providers/session_controller.dart';

/// Routes.
abstract final class Routes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const auth = '/auth';
  static const otp = '/auth/otp';
  static const register = '/auth/register';
  static const onboarding = '/onboarding';
  static const sessionError = '/error';

  static const home = '/home';
  static const jobs = '/jobs';
  static const activeJob = '/jobs/active';
  static String travelMap(String bookingId) => '/jobs/$bookingId/travel-map';
  static const gigs = '/gigs';
  static const gigEditor = '/gigs/edit';
  static const wallet = '/wallet';
  static const transactions = '/wallet/transactions';
  static const payout = '/wallet/payout';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const verification = '/verification';
  static const kyc = '/verification/kyc';
  static const qualification = '/verification/qualification';
  static const bankAccount = '/verification/bank-account';
  static const notifications = '/notifications';
  static const support = '/support';
  static const settings = '/settings';
  static const customerRequests = '/customer-requests';
  static const myOffers = '/my-offers';

  static String job(String id) => '/jobs/$id';
  static String gig(String id) => '/gigs/edit?id=$id';
  static String ticket(String id) => '/support/$id';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: false,

    // The guard reads the resolved session, which is derived from Firebase and
    // from server state. There is no local "isLoggedIn" flag anywhere that a
    // redirect could consult, so a route cannot be reached by setting a boolean.
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final location = state.matchedLocation;

      // Splash is for genuine bootstrap only: no session has ever resolved
      // yet, or the resolved session itself says auth is still being
      // established (SessionLoading, returned only from the very first
      // build()). `session.isLoading` is deliberately NOT consulted here —
      // that flag also flips true on every routine Firebase token refresh and
      // on SessionController.refresh(), neither of which is a real restart,
      // and reacting to it was bouncing the worker back to splash mid-session.
      final value = session.valueOrNull;
      if (value == null || value is SessionLoading) {
        return location == Routes.splash ? null : Routes.splash;
      }
      final isAuthRoute = location.startsWith('/auth') ||
          location == Routes.welcome ||
          location == Routes.splash;

      return switch (value) {
        SessionSignedOut() => isAuthRoute && location != Routes.splash
            ? null
            : Routes.welcome,

        // Authenticated but no profile: registration is the only destination.
        SessionNeedsRegistration() =>
          location == Routes.register ? null : Routes.register,

        // Onboarding incomplete. Support stays reachable — a worker stuck on a
        // step needs to be able to ask for help. KYC must stay reachable too:
        // it is itself a required onboarding step, so excluding it here made
        // every _Step's context.push(Routes.kyc) redirect straight back to
        // /onboarding before the screen ever appeared — no worker could ever
        // reach it to finish setup.
        SessionOnboarding() =>
          location.startsWith(Routes.onboarding) ||
                  location == Routes.support ||
                  location == Routes.kyc
              ? null
              : Routes.onboarding,

        SessionError() =>
          location == Routes.sessionError ? null : Routes.sessionError,

        // Onboarding is left behind too: a session can turn Ready while the
        // worker is still on /onboarding (the last step finishes on a pushed
        // screen), and OnboardingScreen has nothing to show a Ready session.
        SessionReady() => isAuthRoute || location.startsWith(Routes.onboarding)
            ? Routes.home
            : null,

        _ => Routes.splash,
      };
    },

    // Rebuilds the redirect whenever the session changes.
    refreshListenable: _SessionListenable(ref),

    routes: [
      GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: Routes.welcome, builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: Routes.auth, builder: (_, __) => const PhoneEntryScreen()),
      GoRoute(
        path: Routes.otp,
        builder: (_, state) {
          final extra = state.extra;
          return OtpScreen(
            verificationId: extra is Map ? extra['verificationId'] as String? ?? '' : '',
            phoneNumber: extra is Map ? extra['phoneNumber'] as String? ?? '' : '',
          );
        },
      ),
      GoRoute(path: Routes.register, builder: (_, __) => const RegisterScreen()),
      GoRoute(path: Routes.onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(
        path: Routes.sessionError,
        builder: (_, __) => const SessionErrorScreen(),
      ),

      // Four tabs. Home, Jobs, Wallet, Profile — and nothing else, because a
      // worker glancing at this while holding a drill needs to hit the right
      // one without looking.
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen()),
          GoRoute(path: Routes.jobs, builder: (_, __) => const JobsScreen()),
          GoRoute(path: Routes.wallet, builder: (_, __) => const WalletScreen()),
          GoRoute(path: Routes.profile, builder: (_, __) => const ProfileScreen()),
        ],
      ),

      GoRoute(
        path: Routes.activeJob,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const ActiveJobScreen(),
      ),
      GoRoute(
        path: '/jobs/:id/travel-map',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) =>
            TravelMapScreen(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/jobs/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) =>
            JobDetailScreen(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(path: Routes.gigs, builder: (_, __) => const MyGigsScreen()),
      GoRoute(
        path: Routes.gigEditor,
        builder: (_, state) =>
            GigEditorScreen(gigId: state.uri.queryParameters['id']),
      ),
      GoRoute(
        path: Routes.transactions,
        builder: (_, __) => const TransactionsScreen(),
      ),
      GoRoute(path: Routes.payout, builder: (_, __) => const PayoutScreen()),
      GoRoute(
        path: Routes.editProfile,
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: Routes.verification,
        builder: (_, __) => const VerificationScreen(),
      ),
      GoRoute(path: Routes.kyc, builder: (_, __) => const KycScreen()),
      GoRoute(
        path: Routes.qualification,
        builder: (_, __) => const QualificationScreen(),
      ),
      GoRoute(
        path: Routes.bankAccount,
        builder: (_, __) => const BankAccountScreen(),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (_, __) => const NotificationsScreen(),
      ),
      GoRoute(path: Routes.support, builder: (_, __) => const SupportScreen()),
      GoRoute(
        path: '/support/:id',
        builder: (_, state) =>
            TicketThreadScreen(ticketId: state.pathParameters['id']!),
      ),
      GoRoute(path: Routes.settings, builder: (_, __) => const SettingsScreen()),

      // Customer Service Requests (Model B)
      GoRoute(
        path: Routes.customerRequests,
        builder: (_, __) => const CustomerRequestsScreen(),
      ),
      GoRoute(
        path: '/customer-requests/:requestId',
        builder: (_, state) => CustomerRequestDetailScreen(
          requestId: state.pathParameters['requestId']!,
          preloaded: state.extra as CustomerServiceRequest?,
        ),
      ),
      GoRoute(
        path: Routes.myOffers,
        builder: (_, __) => const MyOffersScreen(),
      ),
    ],

    errorBuilder: (_, state) => Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'That screen could not be opened.\n${state.uri}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
});

/// Bridges Riverpod's session state to go_router's refresh mechanism.
class _SessionListenable extends ChangeNotifier {
  _SessionListenable(this._ref) {
    _ref.listen(sessionProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;
}
