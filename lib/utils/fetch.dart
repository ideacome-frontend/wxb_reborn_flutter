import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

const List<String> whiteList = ['/api/user/loginByCode', '/api/alarm/confirmWarnAlarm'];
const List<String> contentTypeList = ['/api/dooraccess/hk/auditUser', '/api/dooraccess/hk/deviceRemote'];

/// you can use [HttpFetch.get]... methods
class HttpFetch {
  static String token;

  /// dio Instance
  static Dio fetchInstance;

  bool _showDialog = false;

  /// return a dio instance with interceptor
  static Dio getInstance() {
    HttpFetch();
    return fetchInstance;
  }

  String baseApi = 'XXXX'; // 配置api地址
  HttpFetch() {
    BaseOptions options = new BaseOptions(
      baseUrl: baseApi,
      responseType: ResponseType.json,
    );
    if (fetchInstance == null) {
      fetchInstance = new Dio(options);
      // 添加拦截器
      fetchInstance.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        // options.uri
        int idx = contentTypeList.indexWhere((test) => options.uri.toString().indexOf(test) >= 0);
        if (idx >= 0) {
          options.contentType = 'application/json';
        }
        // options.headers['Authorization'] = token != null ? "Bearer $token" : null;
        return options; //continue
      }, onResponse: (Response response) {
        /// 拦截器返回的也是个Response 对象，包含如下
        /// HttpHeaders headers;
        /// Options request;
        /// int statusCode;
        /// bool isRedirect;
        /// List<RedirectInfo> redirects ;

        if (response.data["code"] == 500) {
          int idx = whiteList.indexWhere((test) => response.request.uri.toString().indexOf(test) >= 0);
          if (idx >= 0) {
            return response;
          }
          DioError dioError = new DioError(
            error: response.data["message"] ?? response.data["msg"],
          );
          throw dioError;
        }
        if (response.data["code"] == 401 && response.data["msg"] == "Unauthorized") {
          _handleExpried();
        }
        return response;
      }, onError: (DioError e) {
        if (this._showDialog) {
          return e;
        }
        this._showDialog = true;
        if (formatError(e) != "服务器未知错误") {
          ////处理:比如弹窗
        }
        return e; //continue
      }));
    }
    // 开启日志 release建议关闭
    const bool isProduction = const bool.fromEnvironment("dart.vm.product");
    if (!isProduction) {
      fetchInstance.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    }
  }

  static Future get(String url, [Map<String, dynamic> params]) {
    if (fetchInstance == null) {
      HttpFetch();
    }
    return fetchInstance.get(url, queryParameters: params == null ? {} : params);
  }

  static Future post(String url, [Map<String, dynamic> params, Options options]) {
    if (fetchInstance == null) {
      HttpFetch();
    }
    if (options != null) {
      return fetchInstance.post(url, data: params == null ? {} : params, options: options);
    }
    return fetchInstance.post(url, data: params == null ? {} : params);
  }

  static Future put(String url, [Map<String, dynamic> params]) {
    if (fetchInstance == null) {
      HttpFetch();
    }
    return fetchInstance.put(
      url,
      data: params == null ? {} : params,
      options: Options(
        contentType: 'application/json',
      ),
    );
  }

  static Future delete(String url, [Map<String, dynamic> params]) {
    if (fetchInstance == null) {
      HttpFetch();
    }
    return fetchInstance.delete(url, queryParameters: params == null ? {} : params);
  }

  static void setToken(String tk) {
    token = tk;
  }

  //token过期时，显示弹窗，提示重新登录
  _handleExpried() {}
}

String formatError(DioError e) {
  if (e.type == DioErrorType.CONNECT_TIMEOUT) {
    // It occurs when url is opened timeout.
    return "连接超时";
  } else if (e.type == DioErrorType.SEND_TIMEOUT) {
    // It occurs when url is sent timeout.
    return "请求超时";
  } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
    //It occurs when receiving timeout
    return "响应超时";
  } else if (e.type == DioErrorType.RESPONSE) {
    // When the server response, but with a incorrect status, such as 404, 503...
    return "出现异常";
  } else if (e.type == DioErrorType.CANCEL) {
    // When the request is cancelled, dio will throw a error with this type.
    return "请求取消";
  } else {
    debugPrint(e.request.uri.toString());
    //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
    return e.message ?? "未知错误";
  }
}
