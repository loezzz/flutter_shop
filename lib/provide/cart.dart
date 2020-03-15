import 'package:flutter/material.dart';
import 'package:flutter_shop1/model/cartInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = '[]';
  //购物车列表
  List<CartInfoModel> cartList = [];
  //总价格，总商品数量
  double allPrice = 0;
  int allGoodsCount = 0;
  bool isAllCheck = true;//是否全选

  save(goodsId, goodsName, count, price, images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //取值，cartInfo是key值
    cartString = prefs.getString('cartInfo');
    //判断，有值转换成list
    var temp = cartString == null ? [] : json.decode(cartString);
    List<Map> tempList = (temp as List).cast();
    //循环和判断是否有重复(两个变量)
    bool isHave = false;
    int ival = 0;
    allPrice = 0 ;
    allGoodsCount = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        tempList[ival]['count'] = item['count'] + 1;
        cartList[ival].count++;
        isHave = true;
      }
      if(item['isCheck']){
        allPrice += (cartList[ival].price*cartList[ival].count);
        allGoodsCount+=cartList[ival].count;
      }
      ival++;
    });
    if (!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
        'isCheck': true
      };
      tempList.add(newGoods);
      //数据模型也需要增加，但是需要把Map类型数据转化成对象类型
      cartList.add(CartInfoModel.fromJson(newGoods));
      allPrice+=(count*price);
      allGoodsCount +=count;
    }
    //字符串化
    cartString = json.encode(tempList).toString();
    //print('字符串>>>>>>>>>>>>>${cartString}');
    //print('数据模型>>>>>>>>>>>${cartList}');
    //增加方法
    prefs.setString('cartInfo', cartString);
    notifyListeners();
  }

  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    cartList = [];
    print('清空完成................');
    notifyListeners();
  }

  //查询
  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //getString传入一个key值
    cartString = prefs.getString('cartInfo');
    cartList = [];
    if (cartString == null) {
      cartList = [];
    } else {
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      allPrice = 0;
      allGoodsCount = 0;
      isAllCheck=true;
      tempList.forEach((item) {
        if (item['isCheck']) {
          allPrice += (item['count'] * item['price']);
          allGoodsCount += item['count'];
        }else{
          isAllCheck = false;
        }
        cartList.add(CartInfoModel.fromJson(item));
      });
    }
    notifyListeners();
  }

  //删除单个购物车内商品
  deleteOneGoods(String goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    //要转化成List
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    //循环用的索引
    int tempIndex = 0;
    //要删除的索引项
    int delIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList.removeAt(delIndex);
    //转化成String持久化
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    //刷新列表
    await getCartInfo();
  }

  changeCheckState(CartInfoModel cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item){
      if(item['goodsId']==cartItem.goodsId){
        changeIndex=tempIndex;
      }
      tempIndex++;
    });
    //toJson变成Map
    tempList[changeIndex]=cartItem.toJson();
    cartString = json.encode(tempList).toString();
    //持久化
    prefs.setString('cartInfo', cartString);
    await getCartInfo();

  }

  //点击全选按钮操作
  changeAllcheckBtnState(bool isCheck) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    List<Map> newList= [];
    for(var item in tempList){
      var newItem = item;
      newItem['isCheck']= isCheck;
      newList.add(newItem);
    }
    cartString = json.encode(newList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  //商品数量加减
  addOrReduceAction(var cartItem,String todo) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item){
      if(item['goodsId']==cartItem.goodsId){
        changeIndex = tempIndex;
      }
      tempIndex++;
    });

    if(todo=='add'){
      cartItem.count++;
    }else if(cartItem.count>1){
      cartItem.count--;
    }

    tempList[changeIndex]=cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }
}
