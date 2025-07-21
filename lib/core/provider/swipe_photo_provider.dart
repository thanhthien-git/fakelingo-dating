import 'package:flutter/material.dart';

class SwipePhotoProvider with ChangeNotifier {
  int _currentPhoto = 0;

  int get currentPhoto => _currentPhoto;

  void setPhoto(int index) {
    _currentPhoto = index;
    notifyListeners();
  }
  void resetPhoto(){
    _currentPhoto=0;
    notifyListeners();
  }
  void nextPhoto(int max) {
    if (_currentPhoto < max - 1) {
      _currentPhoto++;
      notifyListeners();
    }
  }

  void previousPhoto() {
    if (_currentPhoto > 0) {
      _currentPhoto--;
      notifyListeners();
    }
  }
}
