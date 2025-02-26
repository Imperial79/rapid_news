import 'package:dio/dio.dart';
import 'dart:developer';

import '../Models/Response_Model.dart';

const String baseUrl = "http://baseurlhere";

Future<ResponseModel> apiCallBack({
  String method = 'POST',
  required String path,
  Map<String, dynamic> body = const {},
}) async {
  try {
    if (body.isEmpty) {
      method = "GET";
    }
    final dio = Dio();
    Response response;
    // final Directory appDocDir = await getApplicationDocumentsDirectory();
    // final String appDocPath = appDocDir.path;
    // final jar = PersistCookieJar(
    //   ignoreExpires: true,
    //   storage: FileStorage("$appDocPath/.cookies/"),
    // );
    // dio.interceptors.add(CookieManager(jar));

    // final formData = FormData.fromMap(body);

    if (method == 'POST') {
      response = await dio.post(
        baseUrl + path,
        data: body,
      );
    } else {
      response = await dio.get(baseUrl + path);
    }
    log("$path - ${response.data["message"]}");
    return ResponseModel.fromMap(response.data);
  } catch (e) {
    rethrow;
  }
}
