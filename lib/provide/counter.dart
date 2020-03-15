import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  ///改变的变量
  int _value = 0;
  int get value => _value; //将——value暴露出去
  ///增加逻辑
  add() {
    _value++;
    notifyListeners(); //通知引用变量的地方改变值/// //父类的方法,发出通知
  }
}
