import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as jm;
import 'package:module/base/manager.dart';
import 'package:module/base/hud.dart';
import 'package:module/base/result.dart';

// HttpClient httpClient = HttpClient();

// // 2.构建请求的uri
// final uri = Uri.parse("http://iosserver.ayouhuyu.com/index.php");

// // 3.构建请求
// HttpClientRequest request = await httpClient.postUrl(uri);
// request.headers.contentType = ContentType.parse('application/x-www-form-urlencoded'); //'application/x-www-form-urlencoded';
// request.add(utf8.encode(body));

// // 4.发送请求，必须
// final response = await request.close();
// if (response.statusCode == HttpStatus.ok) {
//   debugPrint(await response.transform(utf8.decoder).join());
// } else {
//   debugPrint('${response.statusCode}');
// }

// return Result.fail('请求异常', 400);

enum NetMode {
  get,
  post,
}

class Http {
  static String aes128KEY = "UEUJJWQQKLAOILQN";
  static String aes128VI = "618336901";

  static final Http _instance = Http._internal();

  factory Http() => _instance;

  late Dio _dio;

  Http._internal() {
    _initDio();
  }

  void _initDio() {
    final headers = {
      "Content-Type": 'application/x-www-form-urlencoded',
    };

    BaseOptions options = BaseOptions(
      baseUrl: 'http://iosserver.ayouhuyu.com/index.php',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: headers,
    );

    _dio = Dio(options);
    // _dio.interceptors.add(LogInterceptor(responseBody: false)); // 请求日志
  }

  static Future<Result> request(
      NetMode mode, String path, Map<String, dynamic> params) async {
    params['channel'] = Platform.isIOS ? 'AppStore' : 'Android';
    params['udid'] = Platform.isIOS ? Manager.global.iOS?.idfa ?? '' : '';
    params['idfa'] = Platform.isIOS ? Manager.global.iOS?.idfa ?? '' : '';

    params['ssid'] = '';
    params['ptmodel'] = Platform.isIOS ? Manager.global.iOS?.model ?? '' : '';
    debugPrint('$params');

    String dataJson = json.encode(params);
    debugPrint(dataJson);

    final sign = Http.signWithInfo(
        path, Manager.global.appID ?? '', Manager.global.appKey ?? '', params);
    // debugPrint(sign);

    Map<String, dynamic> info = {};
    info['appid'] = Manager.global.appID ?? '';
    info['service'] = path;
    info['data'] = dataJson;

    info['platform'] = Platform.isIOS ? 'iOS' : 'Android';
    info['sign'] = sign;

    String body = bodyWithInfo(info);

    try {
      Response res;
      if (mode == NetMode.get) {
        res = await _instance._dio.get('', queryParameters: info);
      } else {
        res = await _instance._dio.post('', data: body);
      }

      return hander(res);
    } catch (error) {
      debugPrint('请求失败$error');
      return Result.fail('请求异常', 404);
    }
  }

  static Future<Result> post(String path, Map<String, dynamic> params) async {
    return Http.request(NetMode.post, path, params);
  }

  static Future<Result> postAlert(
      BuildContext context, String path, Map<String, dynamic> params) async {
    HUD.show();
    final result = await Http.request(NetMode.post, path, params);
    HUD.dismiss();
    return result;
  }

  static String bodyWithInfo(Map<String, dynamic> params) {
    if (params.isEmpty) {
      return '';
    }

    List<String> keys = params.keys.toList();

    String body = '';
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      var value = params[key];
      value = Uri.encodeComponent(value);
      body = '$body$key=$value&';
    }

    body = body.substring(0, body.length - 1);

    return body;
  }

  static String signWithInfo(
      String url, String appid, String appkey, Map<String, dynamic> params) {
    if (params.isEmpty) {
      return '';
    }

    List<String> keys = params.keys.toList();
    keys.sort((a, b) => a.compareTo(b));
    // debugPrint('keys = $keys');

    String sign = '$appid$url';
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      var value = params[key];
      sign = '$sign$key=$value&';
    }

    // debugPrint(sign);
    sign = sign.substring(0, sign.length - 1);
    // debugPrint(sign);
    sign = '$sign$appkey';
    // debugPrint(sign);
    sign = Uri.encodeComponent(sign);
    // debugPrint(sign);
    sign = md5.convert(utf8.encode(sign)).toString();
    // debugPrint(sign);
    return sign;
  }

  static Result hander(Response res) {
    var statusCode = res.statusCode;
    // debugPrint('statusCode = $statusCode');
    if (statusCode == 200) {
      Map<String, dynamic> map = json.decode(res.data);
      debugPrint('map = $map');
      final state = map['state'];
      final code = state['code'];
      final msg = state['msg'];
      if (code == 1) {
        final data = map['data'];
        // debugPrint('state = $state, data = $data');
        return Result.success(data, code, msg: msg);
      } else {
        return Result.fail(msg, code);
      }
    } else {
      return Result.fail('请求失败', statusCode ?? 404);
    }
  }

  static String encode(Map params) {
    if (params.isEmpty) {
      return '';
    }

    const ivText = '12344555544';
    final iv = jm.IV.fromUtf8(ivText);
    final key = jm.Key.fromUtf8(aes128KEY);
    final aes = jm.AES(key, mode: jm.AESMode.cbc);
    final encrypter = jm.Encrypter(aes);

    final dataJson = jsonEncode(params);
    final valueBase64 = encrypter.encrypt(dataJson, iv: iv).base64;

    final ivBase64 = iv.base64;

    final map = {'iv': ivBase64, 'value': valueBase64};

    final encode = base64Encode(utf8.encode(jsonEncode(map)));

    return encode;
  }

  static Map<String, dynamic> decode(String text) {
    if (text.isEmpty) {
      return {};
    }

    final data = base64Decode(text);
    final jsonData = utf8.decode(data);
    final map = jsonDecode(jsonData);

    final ivBase64 = map['iv'];
    final iv = jm.IV.fromBase64(ivBase64);

    final code = map['value'];

    final key = jm.Key.fromUtf8(aes128KEY);
    final aes = jm.AES(key, mode: jm.AESMode.cbc);
    final encrypter = jm.Encrypter(aes);

    final codeJson = encrypter.decrypt64(code, iv: iv);

    return jsonDecode(codeJson);
  }
}
