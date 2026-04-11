/// Reason for closing a trade position.
enum CloseReason {
  tp(name: 'TP'),
  sl(name: 'SL'),
  user(name: 'User'),
  manual(name: 'Manual');

  final String name;

  const CloseReason({required this.name});

  /// Human-readable description.
  String get description => switch (this) {
        CloseReason.tp => 'Take Profit Hit',
        CloseReason.sl => 'Stop Loss Hit',
        CloseReason.user => 'User Closed',
        CloseReason.manual => 'Manual Close',
      };

  /// Whether this close reason indicates a successful exit.
  bool get isPositive => this == CloseReason.tp || this == CloseReason.user;
}
