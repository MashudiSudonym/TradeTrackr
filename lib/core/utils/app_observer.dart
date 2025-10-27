import 'package:trade_trackr/core/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class AppObserver extends ProviderObserver {
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    Constants.logger.d('Provider $context was added with value: $value');
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    Constants.logger.d('Provider $context was disposed');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    Constants.logger.d(
      'Provider $context updated from $previousValue to $newValue',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    Constants.logger.e('Provider $context threw $error at $stackTrace');
  }
}
