class UpiUtils {
  UpiUtils._();

  /// Builds a `upi://pay` deep link for rendering as a scannable QR code.
  ///
  /// `pn` (payee name) is REQUIRED by the UPI spec — do not drop it. UPI
  /// apps (GPay/PhonePe) reject or fail intents missing it, often with an
  /// unrelated-looking generic error rather than a clear "invalid request".
  /// `tr` (transaction reference) is technically optional per spec, but
  /// several apps treat its absence the same way, so always send one —
  /// pass [transactionRefId] (e.g. the booking/order id) when you have one
  /// so it's traceable; otherwise a locally generated id is used.
  static String buildPaymentUri({
    required String upiId,
    required double amount,
    String payeeName = '',
    String note = 'Token booking',
    String? transactionRefId,
  }) {
    //TODO
    final params = {
      'pa': 'paytm.s1bj63f@pty',//upiId,
      'pn': 'SOM FILLING STATION',//payeeName.trim().isEmpty ? 'Har Setu' : payeeName.trim(),
      'am': amount.toStringAsFixed(2),
      'cu': 'INR',
      'tn': note,
      'tr': (transactionRefId == null || transactionRefId.trim().isEmpty)
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : transactionRefId.trim(),
    };
    final query = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    return 'upi://pay?$query';
  }
}