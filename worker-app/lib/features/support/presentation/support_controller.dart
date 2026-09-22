import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/providers.dart';
import '../../../core/errors/result.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/support.dart';

final ticketsProvider =
    FutureProvider.autoDispose<List<SupportTicket>>((ref) async {
  final result = await ref.watch(supportRepositoryProvider).getTickets();
  return result.fold((tickets) => tickets, (failure) => throw failure);
});

final ticketMessagesProvider = StreamProvider.autoDispose
    .family<List<SupportMessage>, String>((ref, ticketId) {
  return ref.watch(supportRepositoryProvider).watchMessages(ticketId);
});

class SupportController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<Result<SupportTicket>> createTicket({
    required String subject,
    required SupportCategory category,
    required String message,
    String? bookingId,
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(supportRepositoryProvider).createTicket(
          subject: subject,
          category: category,
          message: message,
          bookingId: bookingId,
        );
    state = const AsyncData(null);
    ref.invalidate(ticketsProvider);
    return result;
  }

  Future<Result<SupportMessage>> reply({
    required String ticketId,
    required String body,
  }) async {
    final result = await ref
        .read(supportRepositoryProvider)
        .postMessage(ticketId: ticketId, body: body);
    ref.invalidate(ticketsProvider);
    return result;
  }
}

final supportControllerProvider =
    AutoDisposeAsyncNotifierProvider<SupportController, void>(
        SupportController.new);
