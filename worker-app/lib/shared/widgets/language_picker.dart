import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/localization/l10n.dart';

/// A compact button showing the current language, for screens a worker
/// reaches before they can find Settings — the welcome and phone screens
/// above all, since someone who cannot read English has to get past them
/// first.
class LanguageButton extends ConsumerWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    return TextButton.icon(
      onPressed: () => showLanguagePicker(context),
      icon: const Icon(Icons.translate_rounded, size: 20),
      label: Text(locale.nativeName),
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
    builder: (_) => const LanguageList(popOnSelect: true),
  );
}

/// The languages as a list. Used in the picker sheet and inline in Settings.
class LanguageList extends ConsumerWidget {
  const LanguageList({this.popOnSelect = false, super.key});

  final bool popOnSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeControllerProvider);
    final l10n = context.l10n;

    final list = ListView.builder(
      shrinkWrap: true,
      physics: popOnSelect ? null : const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      itemCount: AppLocale.values.length,
      itemBuilder: (context, index) {
        final option = AppLocale.values[index];
        final selected = option == current;
        return ListTile(
          title: Text(
            option.nativeName,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          subtitle: Text(option.englishName),
          trailing: selected
              ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
              : null,
          selected: selected,
          onTap: () {
            ref.read(localeControllerProvider.notifier).setLocale(option);
            if (popOnSelect) Navigator.of(context).pop();
          },
        );
      },
    );

    if (!popOnSelect) return list;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.md),
            child: Text(l10n.languagePickerTitle,
                style: AppTypography.titleLarge),
          ),
          Flexible(child: list),
        ],
      ),
    );
  }
}
