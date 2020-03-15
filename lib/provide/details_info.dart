import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodsInfo = null;

  bool isLeft = true;
  bool isRight = false;
  //tabBar的切换方法
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }

  //从后台获取商品数据
  getGoodInfo(String id) async{
    var formData = {'goodId': id};
    await request('getGoodDetailById', formData: formData).then((val) {
      //把后台数据转化为Map类型的数据
      var responseData = json.decode(val.toString());
      print(responseData);
      //对象化处理
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }
}
