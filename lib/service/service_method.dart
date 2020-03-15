import 'package:dio/dio.dart';
import 'dart:async';
import '../config/service_url.dart';

Future request(url, {formData}) async {
  try {
    //服务器请求容易出现404等异常
    print('开始获取数据..........');
    Response response;
    Dio dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    //var formData = {'lon':'115.02932','lat':'35.76189'};
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    }else{
      response = await dio.post(servicePath[url],data:formData);
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常');
    }
  } catch (e) {
    print(e);
  }
}

//获取首页主题

Future getHomePageContent() async {
  try {
    //服务器请求容易出现404等异常
    print('开始获取首页数据');
    Response response;
    Dio dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    response = await dio.post(servicePath['homePageContent'], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常');
    }
  } catch (e) {
    print(e);
  }
}

//获得火爆专区的商品方法
Future getHomePageBelowConten() async {
  try {
    //服务器请求容易出现404等异常
    print('开始获取火爆专区数据...');
    Response response;
    Dio dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    int page = 1;
    response = await dio.post(servicePath['homePageBelowConten'], data: page);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常');
    }
  } catch (e) {
    print(e);
  }
}
