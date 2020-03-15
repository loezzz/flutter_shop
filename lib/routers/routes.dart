import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

class Routes{
  //确定路由路径
  static String root='/';//根目录
  static String detailsPage = '/detail';
  //路由配置
  static void configureRoutes(Router router){
     //找不到路由时的配置
     router.notFoundHandler = new Handler(
       handlerFunc: (BuildContext context,Map<String,List<String>> params){
          print('ERROR===>ROUTE WAS NOT FOUNF!!!!');
       }
     );
     //配置路由（路径，handler处理）
     router.define(detailsPage, handler: detailsHandler);
  }
}