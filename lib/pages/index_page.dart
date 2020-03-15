import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; //两种不同风格的组件
import 'home_page.dart';
import 'category_page.dart';
import 'cart_page.dart';
import 'member_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../provide/currentIndex.dart';

class IndexPage extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), title: Text('首页')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search), title: Text('分类')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.shopping_cart), title: Text('购物车')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.profile_circled), title: Text('会员中心')),
  ]; //bottomTabs是变量名称

  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    return Consumer<CurrentIndexProvide>(builder: (context, val, child) {
      int currentIndex =
          Provider.of<CurrentIndexProvide>(context, listen: false).currentIndex;
      return Scaffold(
        backgroundColor: Color.fromRGBO(244, 245, 245, 0),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          items: bottomTabs,
          onTap: (index) {
            Provider.of<CurrentIndexProvide>(context,listen: false).changeIndex(index);
          }, //单机事件
        ),
        body: IndexedStack(
          index: currentIndex,
          children: tabBodies,
        ),
      );
    });
  }
}

// class IndexPage extends StatefulWidget {
//   @override
//   _IndexPageState createState() => _IndexPageState();
// }

// class _IndexPageState extends State<IndexPage> {
//   final List<BottomNavigationBarItem>bottomTabs = [
//     BottomNavigationBarItem(
//       icon:Icon(CupertinoIcons.home),
//       title:Text('首页')
//     ),
//     BottomNavigationBarItem(
//       icon:Icon(CupertinoIcons.search),
//       title:Text('分类')
//     ),
//     BottomNavigationBarItem(
//       icon:Icon(CupertinoIcons.shopping_cart),
//       title:Text('购物车')
//     ),
//     BottomNavigationBarItem(
//       icon:Icon(CupertinoIcons.profile_circled),
//       title:Text('会员中心')
//     ),
//   ];//bottomTabs是变量名称

//   final List<Widget> tabBodies = [
//     HomePage(),
//     CategoryPage(),
//     CartPage(),
//     MemberPage()
//   ];

//   int currentIndex = 0;
//   var currentPage ;

// @override
//   void initState() {
//     currentPage = tabBodies[currentIndex];
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     //假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
//     ScreenUtil.init(context, width: 750, height: 1334);
//     //ScreenUtil.init(context);
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(244, 245, 245, 0),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: currentIndex,
//         items: bottomTabs,
//         onTap: (index){
//           setState(() {
//             currentIndex=index;
//             currentPage=tabBodies[currentIndex];
//           });
//         },//单机事件
//       ),
//       body: IndexedStack(
//         index: currentIndex,
//         children: tabBodies,
//       ),
//     );
//   }

// }
