import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/app/config/app_config.dart';
import 'package:wervexa_worker/app/providers/providers.dart';
import 'package:wervexa_worker/app/providers/session_controller.dart';
import 'package:wervexa_worker/core/errors/result.dart';
import 'package:wervexa_worker/data/mappers/mappers.dart';
import 'package:wervexa_worker/domain/entities/enums.dart';
import 'package:wervexa_worker/domain/entities/verification.dart';
import 'package:wervexa_worker/domain/entities/worker.dart';
import 'package:wervexa_worker/domain/repositories/repositories.dart';

/// "What you can do" ticked itself.
///
/// Choosing a main trade adds that trade to worker_services, and the step
/// counted as done whenever that table had a row — so the worker never saw it.
/// It is done only once the worker has reviewed their list.
void main() {
  const config = AppConfig(
    supabaseUrl: 'https://example.supabase.co',
    supabaseAnonKey: 'publishable-key',
    // Empty: the role-claim call to the web tier is skipped.
    apiBaseUrl: '',
    environment: 'test',
    enableCrashReporting: false,
    enableAnalytics: false,
  );

  Future<OnboardingProgress> progressFor(Worker worker) async {
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        // Never emits, so build() stays on SessionLoading and does not reach
        // Firebase; refresh() below resolves the worker directly.
        authStateProvider.overrideWith((ref) => const Stream.empty()),
        authRepositoryProvider.overrideWithValue(_SignedInAuth()),
        workerRepositoryProvider.overrideWithValue(_WorkerRepo(worker)),
        verificationRepositoryProvider.overrideWithValue(_NoVerifications()),
      ],
    );
    addTearDown(container.dispose);

    container.read(sessionProvider);
    await container.read(sessionProvider.notifier).refresh();

    final session = container.read(sessionProvider).requireValue;
    expect(session, isA<SessionOnboarding>());
    return (session as SessionOnboarding).progress;
  }

  test('picking a main trade does not complete "What you can do"', () async {
    final progress = await progressFor(_worker(tradesConfirmedAt: null));

    expect(progress.hasTrade, isTrue);
    expect(progress.hasSkills, isFalse);
    expect(progress.nextStep, OnboardingStep.skills);
  });

  test('reviewing the trade list completes it', () async {
    final progress =
        await progressFor(_worker(tradesConfirmedAt: DateTime(2026, 10, 14)));

    expect(progress.hasSkills, isTrue);
    expect(progress.nextStep, OnboardingStep.serviceArea);
  });

  test('the mapper reads trades_confirmed_at, and absent is null', () {
    final row = {
      'id': 'worker-1',
      'firebase_uid': 'uid-1',
      'worker_code': 'WKR-26-A1B2C3',
      'full_name': 'Ravi Kumar',
      'phone': '+919090909090',
      'status': 'REGISTERED',
      'availability': 'OFFLINE',
    };

    expect(WorkerMapper.fromRow(row).tradesConfirmedAt, isNull);
    final confirmed = WorkerMapper.fromRow(
            {...row, 'trades_confirmed_at': '2026-10-14T09:30:00Z'})
        .tradesConfirmedAt;
    expect(confirmed?.isAtSameMomentAs(DateTime.utc(2026, 10, 14, 9, 30)),
        isTrue);
  });
}

Worker _worker({required DateTime? tradesConfirmedAt}) => Worker(
      id: 'worker-1',
      firebaseUid: 'uid-1',
      workerCode: 'WKR-26-A1B2C3',
      fullName: 'Ravi Kumar',
      phone: '+919090909090',
      status: WorkerStatus.registered,
      availability: WorkerAvailability.offline,
      experienceYears: 0,
      serviceRadiusKm: 10,
      ratingCount: 0,
      jobsCompleted: 0,
      jobsCancelled: 0,
      isKycVerified: false,
      isQualificationVerified: false,
      isSkillVerified: false,
      isBackgroundVerified: false,
      isInsured: false,
      city: 'Pune',
      pincode: '411001',
      gender: 'MALE',
      primaryServiceId: 'electrical',
      tradesConfirmedAt: tradesConfirmedAt,
    );

class _SignedInAuth implements AuthRepository {
  @override
  AuthState get currentState =>
      const AuthSignedIn(firebaseUid: 'uid-1', phoneNumber: '+919090909090');

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _WorkerRepo implements WorkerRepository {
  _WorkerRepo(this.worker);
  final Worker worker;

  @override
  Future<Result<Worker?>> getCurrentWorker() async => Ok(worker);

  // What worker_set_primary_service leaves behind: the main trade, as a skill.
  @override
  Future<Result<List<WorkerSkill>>> getSkills() async => const Ok([
        WorkerSkill(
          serviceId: 'electrical',
          serviceName: 'Electrical',
          serviceSlug: 'electrical',
          isApproved: false,
        ),
      ]);

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _NoVerifications implements VerificationRepository {
  @override
  Future<Result<List<VerificationCase>>> getVerifications() async =>
      const Ok([]);

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
