import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_page_provider.g.dart';

@riverpod
class MainPageController extends _$MainPageController {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }
}
