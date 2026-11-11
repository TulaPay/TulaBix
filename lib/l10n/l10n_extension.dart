import 'package:flutter/widgets.dart';
import 'package:tulapay/l10n/app_localizations.dart';
import 'package:tulapay/models/ledger.dart';

extension AppL10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension BusinessTypeL10n on BuildContext {
  /// Display name for an entry of `businessTypeLabels` (whose English keys
  /// are the in-memory values; the backend only ever sees the snake_case id).
  String businessTypeName(String label) {
    final l = l10n;
    return switch (label) {
      'Registered business' => l.businessTypeRegistered,
      'Informal / SME' => l.businessTypeInformal,
      'Association' => l.businessTypeAssociation,
      _ => l.otherLabel,
    };
  }
}

/// Localized display of the snake_case ledger enums that the models expose as
/// English `*Label` getters (those stay English for CSV exports).
extension LedgerL10n on BuildContext {
  String typeLabel(LedgerTransaction t) {
    final l = l10n;
    return switch (t.type) {
      'payment' => l.typePayment,
      'refund' => l.typeRefund,
      'payout' => l.typePayout,
      'fee' => l.fee,
      'loan_disbursement' => l.typeLoanDisbursement,
      'loan_repayment' => l.typeLoanRepayment,
      _ => t.type,
    };
  }

  String channelName(String channel) {
    final l = l10n;
    return switch (channel) {
      'qr_checkout' => l.qrCheckout,
      'payment_link' => l.paymentLink,
      'card' => l.channelCard,
      'mobile_money' => l.channelMobileMoney,
      'bank_transfer' => l.bankTransfer,
      'cash' => l.channelCash,
      _ => channel,
    };
  }

  String channelLabel(LedgerTransaction t) => channelName(t.channel);

  String paymentModeName(String mode) => channelName(mode);

  String statusName(String s) {
    final l = l10n;
    return switch (s) {
      'completed' => l.completed,
      'pending' => l.pending,
      'failed' => l.failed,
      'processing' => l.processing,
      'paid' => l.paid,
      'scheduled' => l.statusScheduled,
      'refunded' => l.statusRefunded,
      'expired' => l.expired,
      _ => s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1),
    };
  }
}
