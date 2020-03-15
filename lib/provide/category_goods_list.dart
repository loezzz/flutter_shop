import 'package:flutter/material.dart';
import '../model/categoryGoodsList.dart';

class CategoryGoodsListProvide with ChangeNotifier {
  List<CategoryListData> goodsList = [];
  //点击大类时，更换商品列表
  getGoodsList(List<CategoryListData> list){
    goodsList=list;
    //发生变化就监听的方法
    notifyListeners();
  }
 getMoreList(List<CategoryListData> list){
    goodsList.addAll(list);
    //发生变化就监听的方法
    notifyListeners();
  }

}
