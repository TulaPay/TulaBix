/// Money ledger models — `transactions`, `settlement_batches`,
/// `merchant_transfers`, `fee_rates`, plus a client-computed `StatementPeriod`.
/// Shapes follow the control panel's `lib/types/transaction.ts`. All amounts
/// are whole XAF (no minor units).

class LedgerTransaction {
  final String id;
  final String merchantId;
  final String type; // payment | refund | payout | fee | loan_disbursement | loan_repayment
  final String status; // pending | completed | failed | reversed
  final num amount;
  final String amountCurrency;
  final num feeAmount;
  final String channel; // qr_checkout | payment_link | card | mobile_money | bank_transfer
  final String? provider; // mtn_momo | orange_money | visa | mastercard
  final String? counterpartyName;
  final String? counterpartyCustomerId;
  final String? reference;
  final DateTime createdAt;
  final DateTime? settledAt;

  const LedgerTransaction({
    required this.id,
    required this.merchantId,
    required this.type,
    required this.status,
    required this.amount,
    this.amountCurrency = 'XAF',
    this.feeAmount = 0,
    required this.channel,
    this.provider,
    this.counterpartyName,
    this.counterpartyCustomerId,
    this.reference,
    required this.createdAt,
    this.settledAt,
  });

  factory LedgerTransaction.fromMap(Map<String, dynamic> m) => LedgerTransaction(
        id: m['id'] as String,
        merchantId: m['merchant_id'] as String,
        type: m['type'] as String,
        status: m['status'] as String,
        amount: (m['amount'] as num?) ?? 0,
        amountCurrency: (m['amount_currency'] ?? 'XAF') as String,
        feeAmount: (m['fee_amount'] as num?) ?? 0,
        channel: m['channel'] as String,
        provider: m['provider'] as String?,
        counterpartyName: m['counterparty_name'] as String?,
        counterpartyCustomerId: m['counterparty_customer_id'] as String?,
        reference: m['reference'] as String?,
        createdAt: DateTime.parse(m['created_at'].toString()),
        settledAt: m['settled_at'] == null
            ? null
            : DateTime.tryParse(m['settled_at'].toString()),
      );

  /// Money into the merchant (payment, loan_disbursement) is positive;
  /// refunds / payouts / fees are outflows.
  bool get isInflow => type == 'payment' || type == 'loan_disbursement';
  num get signedAmount => isInflow ? amount : -amount;

  String get typeLabel => switch (type) {
        'payment' => 'Payment',
        'refund' => 'Refund',
        'payout' => 'Payout',
        'fee' => 'Fee',
        'loan_disbursement' => 'Loan disbursement',
        'loan_repayment' => 'Loan repayment',
        _ => type,
      };

  String get channelLabel => switch (channel) {
        'qr_checkout' => 'QR checkout',
        'payment_link' => 'Payment link',
        'card' => 'Card',
        'mobile_money' => 'Mobile money',
        'bank_transfer' => 'Bank transfer',
        _ => channel,
      };
}

class SettlementBatch {
  final String id;
  final String merchantId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final num grossAmount;
  final num feeAmount;
  final num netAmount;
  final String currency;
  final String status; // scheduled | processing | paid | failed
  final String payoutAccount;
  final DateTime? paidAt;

  const SettlementBatch({
    required this.id,
    required this.merchantId,
    required this.periodStart,
    required this.periodEnd,
    required this.grossAmount,
    required this.feeAmount,
    required this.netAmount,
    this.currency = 'XAF',
    required this.status,
    required this.payoutAccount,
    this.paidAt,
  });

  factory SettlementBatch.fromMap(Map<String, dynamic> m) => SettlementBatch(
        id: m['id'] as String,
        merchantId: m['merchant_id'] as String,
        periodStart: DateTime.parse(m['period_start'].toString()),
        periodEnd: DateTime.parse(m['period_end'].toString()),
        grossAmount: (m['gross_amount'] as num?) ?? 0,
        feeAmount: (m['fee_amount'] as num?) ?? 0,
        netAmount: (m['net_amount'] as num?) ?? 0,
        currency: (m['currency'] ?? 'XAF') as String,
        status: m['status'] as String,
        payoutAccount: (m['payout_account'] ?? '') as String,
        paidAt: m['paid_at'] == null
            ? null
            : DateTime.tryParse(m['paid_at'].toString()),
      );
}

class MerchantTransfer {
  final String id;
  final String kind; // bank | internal
  final String sourceLabel;
  final String destinationLabel;
  final num amount;
  final String currency;
  final String? note;
  final String status; // pending | completed | failed
  final DateTime createdAt;

  const MerchantTransfer({
    required this.id,
    required this.kind,
    required this.sourceLabel,
    required this.destinationLabel,
    required this.amount,
    this.currency = 'XAF',
    this.note,
    required this.status,
    required this.createdAt,
  });

  factory MerchantTransfer.fromMap(Map<String, dynamic> m) => MerchantTransfer(
        id: m['id'] as String,
        kind: m['kind'] as String,
        sourceLabel: (m['source_label'] ?? '') as String,
        destinationLabel: (m['destination_label'] ?? '') as String,
        amount: (m['amount'] as num?) ?? 0,
        currency: (m['currency'] ?? 'XAF') as String,
        note: m['note'] as String?,
        status: m['status'] as String,
        createdAt: DateTime.parse(m['created_at'].toString()),
      );
}

class FeeRate {
  final String channel;
  final num percent;
  final num fixedFeeXaf;

  const FeeRate({
    required this.channel,
    required this.percent,
    required this.fixedFeeXaf,
  });

  factory FeeRate.fromMap(Map<String, dynamic> m) => FeeRate(
        channel: m['channel'] as String,
        percent: (m['percent'] as num?) ?? 0,
        fixedFeeXaf: (m['fixed_fee_xaf'] as num?) ?? 0,
      );
}

/// Computed client-side from the ledger for a date range — mirrors the control
/// panel's `MerchantStatementPeriod` (`lib/types/statement.ts`).
class StatementPeriod {
  final DateTime periodStart;
  final DateTime periodEnd;
  final num grossRevenue; // completed payments + cash receipts
  final num refunds; // completed refunds
  final num feesCharged;
  final num payoutsReceived; // completed payouts
  final int transactionCount;

  const StatementPeriod({
    required this.periodStart,
    required this.periodEnd,
    required this.grossRevenue,
    required this.refunds,
    required this.feesCharged,
    required this.payoutsReceived,
    required this.transactionCount,
  });

  num get netRevenue => grossRevenue - refunds;

  factory StatementPeriod.compute({
    required DateTime from,
    required DateTime to,
    required List<LedgerTransaction> transactions,
    required List<CashReceiptLike> cashReceipts,
  }) {
    num gross = 0, refunds = 0, fees = 0, payouts = 0;
    var count = 0;
    for (final t in transactions) {
      if (t.createdAt.isBefore(from) || t.createdAt.isAfter(to)) continue;
      if (t.status != 'completed') continue;
      count++;
      switch (t.type) {
        case 'payment':
        case 'loan_disbursement':
          gross += t.amount;
        case 'refund':
          refunds += t.amount;
        case 'payout':
          payouts += t.amount;
        case 'fee':
          fees += t.amount;
      }
      fees += t.feeAmount;
    }
    for (final r in cashReceipts) {
      if (r.createdAt.isBefore(from) || r.createdAt.isAfter(to)) continue;
      gross += r.amount;
      count++;
    }
    return StatementPeriod(
      periodStart: from,
      periodEnd: to,
      grossRevenue: gross,
      refunds: refunds,
      feesCharged: fees,
      payoutsReceived: payouts,
      transactionCount: count,
    );
  }
}

/// Minimal shape the statement aggregator needs from a cash receipt, so
/// `ledger.dart` doesn't have to import `commerce.dart`.
abstract class CashReceiptLike {
  DateTime get createdAt;
  num get amount;
}
