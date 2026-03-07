import 'package:share_plus/share_plus.dart';

class ShareNote {
  Future<void> call({required String title, required String content}) async {
    await Share.share('$title\n\n$content');
  }
}
