import 'package:flutter/foundation.dart';

class CountModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  set count(int value) {
    _count = value;
    notifyListeners();
  }

  CountModel(this._count);
}
