import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/localization/l10n.dart';

/// A compact button showing the current language, for screens a customer
/// reaches before they can find the setting — the phone number screen above
/// all, since someone who cannot read English has to get past it first.
class LanguageButton extends ConsumerWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    return TextButton.icon(
      onPressed: () => showLanguagePicker(context),
      icon: const Icon(Icons.translate_rounded, size: 18),
      label: Text(locale.nativeName),
      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
    );
  }
}

/// Lists every language by its own name, with the English name beneath, and
/// switches the app the moment one is tapped.
Future<void> showLanguagePicker(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _LanguageSheet(),
  );
}

class _LanguageSheet extends ConsumerWidget {
  const _LanguageSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeControllerProvider);
    final l10n = context.l10n;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Text(
              l10n.languagePickerTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: AppLocale.values.length,
              itemBuilder: (context, index) {
                final option = AppLocale.values[index];
                final selected = option == current;
                return ListTile(
                  title: Text(
                    option.nativeName,
                    style: TextStyle(
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(option.englishName),
                  trailing: selected
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary)
                      : null,
                  selected: selected,
                  onTap: () {
                    ref
                        .read(localeControllerProvider.notifier)
                        .setLocale(option);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
