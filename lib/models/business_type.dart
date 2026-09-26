/// Display label -> merchants.business_type literal (migration 0037).
/// Shared between sign_up.dart (initial selection) and
/// business_information_screen.dart (shown again, editable) so the two
/// screens can't drift out of sync with each other.
const Map<String, String> businessTypeLabels = {
  'Registered business': 'registered_business',
  'Informal / SME': 'informal_sme',
  'Association': 'association',
  'Other': 'other',
};

String? businessTypeLabelFor(String literal) {
  for (final entry in businessTypeLabels.entries) {
    if (entry.value == literal) return entry.key;
  }
  return null;
}
