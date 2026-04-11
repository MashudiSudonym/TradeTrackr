/// Type of financial transaction.
enum FinanceType {
  deposit(name: 'Deposit'),
  withdrawal(name: 'Withdrawal');

  final String name;

  const FinanceType({required this.name});

  bool get isDeposit => this == FinanceType.deposit;
  bool get isWithdrawal => this == FinanceType.withdrawal;
}
