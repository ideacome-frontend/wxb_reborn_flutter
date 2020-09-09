import 'package:mobx/mobx.dart';

part 'app_bar.g.dart';

class AppBarStore = _AppBarStore with _$AppBarStore;

abstract class _AppBarStore with Store {
  @observable
  String title = '';

  @observable
  bool show = false;

  @observable
  String shareUrl = '';

  @action
  setAppBar({String title, bool show, String shareUrl}) {
    if (title != null && title.isNotEmpty) {
      this.title = title;
    }
    if (show != null) {
      this.show = show;
    }
    if (shareUrl != null && shareUrl.isNotEmpty) {
      this.shareUrl = '';
    }
  }
}

final AppBarStore $appBarStore = new AppBarStore();
