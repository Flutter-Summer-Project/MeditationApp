import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setFlag(bool flag) {
    state = flag;
  }
}


final flagNotifierProvider = NotifierProvider<CommentNotifier, bool>((){
  return CommentNotifier();
});