import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../Utils/Widgets/custom_snackbar.dart';
import '../../Utils/constant.dart';
import '../Model/error_model.dart';
import 'api_exception.dart';

const String jsonContentType = 'application/json';

///
/// This class contain the Comman methods of API
///
class ApiManager {
  ///
  /// Replace base url with this
  ///
  static const String baseUrl = "https://www.prayasapp.in/api/";

  ///
  /// This method is used for call API for the `POST` method, need to pass API Url endpoint
  ///
  Future<dynamic> get(String url,
      {bool isLoaderShow = true, bool isErrorSnackShow = true}) async {
    Get.printInfo(info: 'Api Post, url $url');
    try {
      if (isLoaderShow) {
        EasyLoading.show();
      }

      ///
      /// Declare the header for the request, if user not loged in then pass emplty array as header
      /// or else pass the authentication token stored on login time
      ///
      Map<String, String> header =
          GetStorage().read(AppPreferencesHelper.USER_INFO) != null
              ? {
                  'Content-Type': 'multipart/form-data',
                  'Authorization': 'Bearer ',
                }
              : {'Content-Type': 'multipart/form-data'};

      Get.printInfo(info: 'header- ${header.toString()}');
      Get.printInfo(info: 'URL- ${baseUrl + url}');

      ///
      /// Make the post method api call with header and given parameter
      ///
      final request = http.MultipartRequest("GET", Uri.parse(baseUrl + url));
      request.headers.addAll(header);
      http.StreamedResponse response =
          await request.send().timeout(Duration(seconds: 15));
      print(response.headers);

      ///
      /// Handle response and errors
      ///
      var map = _returnResponse(response,
          isShow: isErrorSnackShow, isLoaderShow: isLoaderShow);

      ///
      /// Return the map response here and handle it in you model class accordigly
      ///
      return map;
    } on SocketException {
      Get.printInfo(info: 'No net');
      SnackBars.errorSnackBar(content: 'No Internet');
      throw FetchDataException('No Internet connection');
    } finally {
      if (isLoaderShow) {
        EasyLoading.dismiss();
      }
    }
  }

  ///
  /// This method is used for call API for the `POST` method, need to pass API Url endpoint
  ///
  Future<dynamic> post(String url, Map<String, String> parameters,
      {String objcontentType = jsonContentType,
      bool isLoaderShow = true,
      bool isErrorSnackShow = true,
      http.MultipartFile? file}) async {
    Get.printInfo(info: 'Api Post, url $url');
    try {
      if (isLoaderShow) {
        EasyLoading.show();
      }

      ///
      /// Declare the header for the request, if user not loged in then pass emplty array as header
      /// or else pass the authentication token stored on login time
      ///
      Map<String, String> header =
          GetStorage().read(AppPreferencesHelper.USER_INFO) != null
              ? {
                  'Content-Type': 'multipart/form-data',
                  'Authorization': 'Bearer ',
                }
              : {'Content-Type': 'multipart/form-data'};

      Get.printInfo(info: 'header- ${header.toString()}');
      Get.printInfo(info: 'URL- ${baseUrl + url}');
      Get.printInfo(info: 'BODY PARAMS- $parameters');

      ///
      /// Make the post method api call with header and given parameter
      ///
      final request = http.MultipartRequest("POST", Uri.parse(baseUrl + url));
      request.fields.addAll(parameters);
      if (file != null) {
        request.files.add(file);
      }

      request.headers.addAll(header);
      http.StreamedResponse response = await request.send();

      ///
      /// Handle response and errors
      ///
      var map = _returnResponse(response,
          isShow: isErrorSnackShow, isLoaderShow: isLoaderShow);

      ///
      /// Return the map response here and handle it in you model class accordigly
      ///
      return map;
    } on SocketException {
      Get.printInfo(info: 'No net');
      SnackBars.errorSnackBar(content: 'No Internet');
      throw FetchDataException('No Internet connection');
    } finally {
      if (isLoaderShow) {
        EasyLoading.dismiss();
      }
    }
  }

  dynamic _returnResponse(http.StreamedResponse response,
      {bool isShow = true, bool isLoaderShow = true}) async {
    if (isLoaderShow) {
      EasyLoading.dismiss();
    }
    var responseString = await response.stream.bytesToString();
    if (kDebugMode) {
      print(response.statusCode);
      print(responseString);
    }
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(responseString);
        // if (responseJson['code'] == 0) {
        //   if (isShow) {
        //     SnackBars.errorSnackBar(content: responseJson['msg']);
        //   }
        //   throw BadRequestException(responseJson['msg']);
        // }
        return responseJson;
      case 201:
        var responseJson = json.decode(responseString);
        // if (responseJson['code'] == 0) {
        //   if (isShow) {
        //     SnackBars.errorSnackBar(content: responseJson['msg']);
        //   }
        //   throw BadRequestException(responseJson['msg']);
        // }
        return responseJson;
      case 400:
        if (isShow) {
          SnackBars.errorSnackBar(
              content: ErrorModel.fromJson(json.decode(responseString)).msg!);
        }
        throw BadRequestException(
            ErrorModel.fromJson(json.decode(responseString)).msg!);
      case 401:
        if (isShow) {
          SnackBars.errorSnackBar(
              content: ErrorModel.fromJson(json.decode(responseString)).msg!);
        }
        throw BadRequestException(
            ErrorModel.fromJson(json.decode(responseString)).msg!);
      case 403:
        if (isShow) {
          SnackBars.errorSnackBar(
              content: ErrorModel.fromJson(json.decode(responseString)).msg!);
        }
        throw UnauthorisedException(
            ErrorModel.fromJson(json.decode(responseString)).msg!);

      case 404:
        if (isShow) {
          SnackBars.errorSnackBar(
              content: ErrorModel.fromJson(json.decode(responseString)).msg!);
        }
        throw UnauthorisedException(
            ErrorModel.fromJson(json.decode(responseString)).msg!);
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
