import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart'; //通用的调用后端接口的方法
import 'dart:convert';
import '../model/category.dart';
import '../model/categoryGoodsList.dart';
import '../provide/child_category.dart';
import 'package:provider/provider.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
//Json格式化网站http://www.bejson.com/
//Json_to_dart网站https://javiercbk.github.io/json_to_dart/

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('商品分类')),
      body: Container(
        child: Row(children: <Widget>[
          LeftCategoryNav(),
          Column(children: <Widget>[RightCategoryNav(), CategoryGoodsList()])
        ]),
      ),
    );
  }
}

class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0;
  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().setWidth(180),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: 1, color: Colors.black12),
          ),
        ),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _leftInkWell(index);
          },
        ));
  }

  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      //要在这个点击大类的点击事件作状态管理
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        Provider.of<ChildCategory>(context, listen: false)
            .getChildCategory(childList, categoryId);
        _getGoodsList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
          //装饰器
          color:
              isClick ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white, //底色
          border: Border(
            //设置边
            bottom: BorderSide(width: 1, color: Colors.black12),
          ),
        ),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }

  //得到后台数据
  void _getCategory() async {
    await request('getCategory').then((val) {
      //print('val的值为>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      //print('${val}');
      var data = json.decode(val.toString()); //转成json
      //print('data的值为>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      //print('${data}');
      //利用数据模型，输出每一个大类的名称
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      Provider.of<ChildCategory>(context, listen: false)
          .getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
      //list.data.forEach((item)=>print(item.mallCategoryName));
    });
  }

  //点击大类获得小类商品列表方法
  void _getGoodsList({String categoryId}) async {
    //参数：

    //categoryId:大类ID，字符串类型
    //categorySubId : 子类ID，字符串类型，如果没有可以填写空字符串，例如''
    //page: 分页的页数，int类型
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': "",
      'page': '1'
    };
    await request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      //print('>>>>>>>>>>>>>>>>>>>${goodsList.data[0].goodsName}');
      //修改列表状态
      Provider.of<CategoryGoodsListProvide>(context, listen: false)
          .getGoodsList(goodsList.data);
    });
  }
}

//小类右侧导航
class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  //List list = ['名酒','宝丰','北京二锅头','舍得','五粮液','茅台','散白'];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Consumer(builder: (context, ChildCategory childCategory, child) {
      return Container(
        height: ScreenUtil().setSp(80),
        width: ScreenUtil().setWidth(570),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: ListView.builder(
          scrollDirection: Axis.horizontal, //水平布局
          itemCount: childCategory.childCategoryList.length,
          itemBuilder: (context, index) {
            return _rightInkWell(index, childCategory.childCategoryList[index]);
          },
        ),
      );
    }));
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick =
        (index == Provider.of<ChildCategory>(context, listen: false).childIndex)
            ? true
            : false;
    return InkWell(
      onTap: () {
        Provider.of<ChildCategory>(context, listen: false)
            .changeChildIndex(index, item.mallSubId);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: isClick ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

//小类的获取数据方法
  void _getGoodsList(String categorySubId) async {
    //参数：

    //categoryId:大类ID，字符串类型
    //categorySubId : 子类ID，字符串类型，如果没有可以填写空字符串，例如''
    //page: 分页的页数，int类型
    var data = {
      'categoryId':
          Provider.of<ChildCategory>(context, listen: false).categoryId,
      'categorySubId': categorySubId,
      'page': '1'
    };
    await request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      //print('>>>>>>>>>>>>>>>>>>>${goodsList.data[0].goodsName}');
      //修改列表状态
      if (goodsList.data == null) {
        Provider.of<CategoryGoodsListProvide>(context, listen: false)
            .getGoodsList([]);
      } else {
        Provider.of<CategoryGoodsListProvide>(context, listen: false)
            .getGoodsList(goodsList.data);
      }
    });
  }
}

//商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  
  GlobalKey<RefreshFooterState> _footerkey = new GlobalKey<RefreshFooterState>();
  var scrollController = new ScrollController();
  
  //在这里初始化状态，调用获取商品列表函数
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryGoodsListProvide>(
      builder: (context, data, child) {
        try{
           if(Provider.of<ChildCategory>(context,listen:false).page==1){
              //每次切换page=1,但列表位置要放在最上面
              scrollController.jumpTo(0.0);
           }
        }catch(e){
             print('进入页面第一次初始化：${e}');
        }
        if (data.goodsList.length > 0) {
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570),
              height: ScreenUtil().setHeight(1000),
              //height: ScreenUtil().setHeight(978),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                    key: _footerkey,
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    moreInfoColor: Colors.pink,
                    showMore: true,
                    noMoreText: Provider.of<ChildCategory>(context,listen:false).noMoreText,
                    moreInfo: '加载中',
                    loadReadyText: '上拉加载...'),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: data.goodsList.length,
                  itemBuilder: (context, index) {
                    return _listWidget(data.goodsList, index);
                  },
                ),
                loadMore: ()async{
                  print('上拉加载更多');
                  _getMoreList();
                },
              ),
            ),
          );
        } else {
          return Text('暂时没有数据');
        }
      },
    );
  }
  void _getMoreList() async {
    Provider.of<ChildCategory>(context, listen: false).addPage();
    //参数：

    //categoryId:大类ID，字符串类型
    //categorySubId : 子类ID，字符串类型，如果没有可以填写空字符串，例如''
    //page: 分页的页数，int类型
    var data = {
      'categoryId':
          Provider.of<ChildCategory>(context, listen: false).categoryId,
      'categorySubId': 
          Provider.of<ChildCategory>(context,listen:false).subId,
      'page':  
          Provider.of<ChildCategory>(context,listen:false).page,
    };
    await request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      //print('>>>>>>>>>>>>>>>>>>>${goodsList.data[0].goodsName}');
      //修改列表状态
      if (goodsList.data == null) {
        //轻提示插件的使用
        Fluttertoast.showToast(
           msg: '已经到底啦',
           toastLength: Toast.LENGTH_SHORT,//提示插件的大小
           gravity: ToastGravity.CENTER,//提示的位置
           backgroundColor: Colors.pink,
           textColor: Colors.white,
           fontSize: 16.0
        );
        Provider.of<ChildCategory>(context,listen:false).chageNoMore('没有更多了');
      } else {
        Provider.of<CategoryGoodsListProvide>(context, listen: false)
            .getMoreList(goodsList.data);
      }
    });
  }

  //商品图片的Widget
  Widget _goodsImage(List newList, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  //商品名的Widget
  Widget _goodsName(List newList, index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis, //超过显示省略号
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  //商品价格的Widget
  Widget _goodsPrice(List newList, index) {
    return Container(
      width: ScreenUtil().setWidth(370),
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Text(
            '价格：￥${newList[index].presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '价格：￥${newList[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }

  //组合起来
  Widget _listWidget(List newList, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white, //背景白色
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.black26))),
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
