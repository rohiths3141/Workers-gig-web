import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// The entry point to the service assistant.
///
/// An extended FAB rather than a plain icon: the first time someone sees it,
/// "Ask AI" has to say what it does, because nothing else on the home screen
/// invites a customer to type a sentence instead of picking a category.
class AskAssistantButton extends StatelessWidget {
  const AskAssistantButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 3,
      icon: const Icon(Icons.auto_awesome_rounded, size: 20),
      label: const Text(
        'Ask AI',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    );
  }
}
