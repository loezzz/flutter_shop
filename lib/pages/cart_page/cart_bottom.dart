import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provide/cart.dart';

class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      color: Colors.white,
      child: Consumer<CartProvide>(builder: (context, val, child) {
        return Row(children: <Widget>[
          selectAllBtn(context),
          allPriceArea(context),
          goButton(context),
        ]);
      }),
    );
  }

  //全选区域
  Widget selectAllBtn(context) {
    bool isAllCheck = Provider.of<CartProvide>(context,listen: false).isAllCheck;
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: isAllCheck,
            activeColor: Colors.pink,
            onChanged: (bool val) {
              Provider.of<CartProvide>(context,listen: false).changeAllcheckBtnState(val);
            },
          ),
          Text('全选'),
        ],
      ),
    );
  }

  Widget allPriceArea(context) {
    double allPrice = Provider.of<CartProvide>(context, listen: false).allPrice;
    return Container(
      width: ScreenUtil().setWidth(430),
      child: Column(children: <Widget>[
        Row(children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            width: ScreenUtil().setWidth(280),
            child: Text(  
              '合计：',
              style: TextStyle(fontSize: ScreenUtil().setSp(36)),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: ScreenUtil().setWidth(150),
            child: Text(
              '￥${allPrice}',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(36), color: Colors.red),
            ),
          ),
        ]),
        Container(
          width: ScreenUtil().setWidth(430),
          alignment: Alignment.centerRight,
          child: Text('满10元免配送费，预购免配送费',
              style: TextStyle(
                  color: Colors.black38, fontSize: ScreenUtil().setSp(22))),
        )
      ]),
    );
  }

  Widget goButton(context) {
    int allGoodsCount =
        Provider.of<CartProvide>(context, listen: false).allGoodsCount;
    return Container(
      width: ScreenUtil().setWidth(160),
      padding: EdgeInsets.only(left: 10),
      child: InkWell(
        onTap: () {},
        child: Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(3.0)),
            child: Text(
              '结算(${allGoodsCount})',
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
