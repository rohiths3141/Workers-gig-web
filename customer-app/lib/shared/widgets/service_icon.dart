import 'package:flutter/material.dart';

import '../../core/localization/l10n.dart';

/// The icon and accent colour for a service category.
///
/// One definition, used by the home grid and the assistant's match cards. A
/// customer who is told "that sounds like Plumbing" should see the same mark
/// they tapped on the home screen — two different icons for one service reads
/// as two different services.
IconData serviceIconFor(String slug) {
  switch (slug.toLowerCase()) {
    case 'electrician':
    case 'electrical':
      return Icons.bolt_rounded;
    case 'plumbing':
    case 'plumber':
      return Icons.plumbing_rounded;
    case 'carpentry':
    case 'carpenter':
      return Icons.handyman_rounded;
    case 'cleaning':
      return Icons.cleaning_services_rounded;
    case 'appliance':
    case 'appliance-repair':
      return Icons.build_circle_outlined;
    case 'ac-repair':
    case 'ac-service':
      return Icons.ac_unit_rounded;
    case 'painting':
      return Icons.format_paint_rounded;
    case 'pest-control':
      return Icons.pest_control_rounded;
    default:
      return Icons.home_repair_service_rounded;
  }
}

/// A service category's name in the language on screen.
///
/// The catalogue stores one English name per category. The categories the
/// platform launched with are translated here, matched by slug or, where a
/// screen only has the name, by that English name. A category added to the
/// catalogue later shows its stored name until it is added here.
String localizedServiceName(
  AppLocalizations l10n,
  String name, {
  String? slug,
}) {
  final key = (slug ?? name).toLowerCase().trim().replaceAll(' ', '-');
  switch (key) {
    case 'electrical':
    case 'electrician':
      return l10n.serviceElectrical;
    case 'plumbing':
    case 'plumber':
      return l10n.servicePlumbing;
    case 'ac-service':
    case 'ac-repair':
      return l10n.serviceAcService;
    case 'appliance-repair':
    case 'appliance':
      return l10n.serviceApplianceRepair;
    case 'carpentry':
    case 'carpenter':
      return l10n.serviceCarpentry;
    case 'painting':
      return l10n.servicePainting;
    case 'cleaning':
      return l10n.serviceCleaning;
    case 'pest-control':
      return l10n.servicePestControl;
    case 'other-home-services':
      return l10n.serviceOtherHome;
  }
  return slug != null ? localizedServiceName(l10n, name) : name;
}

/// A saved address's label. The three the app offers are stored in English
/// and shown in the language on screen; anything the customer typed is theirs.
String localizedAddressLabel(AppLocalizations l10n, String label) =>
    switch (label) {
      'Home' => l10n.addressLabelHome,
      'Work' => l10n.addressLabelWork,
      'Other' => l10n.addressLabelOther,
      _ => label,
    };

/// Accent colours, assigned by the service's position in the catalogue so
/// the same category keeps the same colour everywhere it appears.
const serviceAccentColors = <Color>[
  Color(0xFFEF4444),
  Color(0xFF2F63E8),
  Color(0xFFF59E0B),
  Color(0xFF22B573),
  Color(0xFF06B6D4),
  Color(0xFFA855F7),
  Color(0xFFF97316),
  Color(0xFF6B7280),
];

/// The accent for the service at [index] in the catalogue, which is the
/// same ordering every screen renders it in. A negative index means the
/// service was not found in the catalogue; it falls back to the last, most
/// neutral colour rather than throwing.
Color serviceAccentAt(int index) => index < 0
    ? serviceAccentColors.last
    : serviceAccentColors[index % serviceAccentColors.length];
