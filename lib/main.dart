import 'package:flutter/material.dart'; //material.dart 和 cupertino.dart
import './pages/index_page.dart';
import 'package:provider/provider.dart';
import './provide/counter.dart'; //引入数据仓库
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
import './provide/currentIndex.dart';
import 'package:fluro/fluro.dart';
import './routers/routes.dart';
import './routers/application.dart';
import './provide/details_info.dart';
import './provide/cart.dart';

void main() {
  //顶层依赖 不懂

  //var counter = Counter();
  //var providers = Providers();
  //providers..provide(Provider<Counter>.value(counter));
  //runApp(ProviderNode(child:MyApp(),providers:providers));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(
        value: Counter(),
      ),
      ChangeNotifierProvider.value(
        value: ChildCategory(),
      ),
      ChangeNotifierProvider.value(
        value: CategoryGoodsListProvide(),
      ),
      ChangeNotifierProvider.value(
        value: DetailsInfoProvide(),
      ),
      ChangeNotifierProvider.value(
        value: CartProvide(),
      ),
      ChangeNotifierProvider.value(
        value: CurrentIndexProvide(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //路由顶层注入
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
    return Container(
      child: MaterialApp(
          title: '百姓生活+',
          onGenerateRoute: Application.router.generator,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: Colors.pink),
          home: IndexPage()),
    );
  }
}
