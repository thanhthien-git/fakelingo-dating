import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fakelingo/core/constants/api_url.dart';
import 'package:fakelingo/core/models/user_model.dart';
import 'package:fakelingo/core/services/http_service.dart';

class UserService {
  final Dio _dio = HttpService().dio;

  Future<User?> myProfile() async {
    try {
      final response = await _dio.get(ApiUrl.myProfile);
      return User.fromJson(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    int? age,
    String? gender,
    String? bio,
    Map<String, dynamic>? location,
    List<String>? interests,
  }) async {
    try {
      final Map<String, dynamic> profileData = {};
      if (name != null) profileData['name'] = name;
      if (age != null) profileData['age'] = age;
      if (gender != null) profileData['gender'] = gender;
      if (bio != null) profileData['bio'] = bio;
      if (location != null) {
        profileData['location'] = location;
      }
      if (interests != null) profileData['interests'] = interests;

      final requestBody = {'profile': profileData};

      final response = await _dio.patch(
        ApiUrl.updateProfile,
        data: jsonEncode(requestBody),
      );

      return {'success': true, 'data': response};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối'};
    }
  }

  Future<Map<String, dynamic>> updatePhotos({
    required List<File> newFiles,
  }) async {
    try {
      final formData = FormData();
      for (var file in newFiles) {
        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(file.path),
          ),
        );
      }

      final response = await _dio.patch(
        ApiUrl.updatePhotos,
        data: formData,
      );

      return {'success': true, 'data': response.data};
    } catch (e) {
      print('Upload error: $e');
      return {'success': false, 'message': 'Lỗi tải ảnh lên'};
    }
  }
}
