import 'package:share_plus/share_plus.dart';

typedef ShareFunction = Future<void> Function(String text);

class ShareNote {
  final ShareFunction _share;

  ShareNote({ShareFunction? share})
      : _share = share ?? _defaultShare;

  static Future<void> _defaultShare(String text) async {
    await Share.share(text);
  }

  Future<void> call({required String title, required String content}) async {
    await _share('$title\n\n$content');
  }
}
