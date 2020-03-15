import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0;//子类高亮索引
  String categoryId = '4';//大类ID
  String subId = '';//小类
  int page = 1;//列表页数
  String noMoreText = '';//显示没有数据的文字


  ///改变的变量
  ///增加逻辑
  getChildCategory(List<BxMallSubDto> list,String id) { 
    //点击大类索引变为0
    childIndex= 0;
    page= 1;
    noMoreText='';
    //添加‘全部’分类
    BxMallSubDto all =BxMallSubDto();
    all.mallSubId='';
    all.mallCategoryId='00';
    all.mallSubName='全部';
    all.comments='null';
    childCategoryList = [all];
    childCategoryList.addAll(list);//这里添加一定要设置泛型
    notifyListeners(); //通知引用变量的地方改变值/// //父类的方法,发出通知
  }

  //改变子类索引
  changeChildIndex(index,String id){
    page= 1;
    noMoreText='';
    childIndex = index;
    subId = id;
    notifyListeners();
  }
  //增加page的方法
  addPage(){
    page++;

  }

  chageNoMore(String text){
    noMoreText=text;
    notifyListeners();
  }
}
