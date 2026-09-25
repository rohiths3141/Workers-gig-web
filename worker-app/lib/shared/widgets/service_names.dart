import '../../core/localization/l10n.dart';

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
