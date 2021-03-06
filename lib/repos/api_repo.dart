import 'package:dio/dio.dart';
import 'package:flutter_dio_pacakge/model/list_user_response.dart';
import '../model/single_user_response.dart';
import '../model/user_model.dart';
import '.././http_calls/http_service.dart';
import '../http_calls/NETWORK_EXCEPTIONS/network_exceptions.dart';
import '../http_calls/API_RESULTS/api_result.dart';

class APIRepository {
  DioClient dioClient;
  String _baseUrl = "https://reqres.in/";

  APIRepository() {
    var dio = Dio();

    dioClient = DioClient(_baseUrl, dio);
  }

  Future<ApiResult<User>> fetchSingleUser() async {
    try {
      final response = await dioClient.get('api/users/2');
      print(response);
      SingleUserResponse _singleUser = SingleUserResponse.fromJson(response);
      User user = _singleUser.user;
      return ApiResult.success(data: user);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ListUserResponse>> fetchListOfUser() async {
    try {
      final response = await dioClient.get('api/users?page=2');
      print(response);
      ListUserResponse user = ListUserResponse.fromJson(response);
      return ApiResult.success(data: user);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
  Future<ApiResult<bool>> deleteUser(int userId) async {
    try {
      final response = await dioClient.delete('api/users/$userId');
      print(response);

      return ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
