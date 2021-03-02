import 'package:dio/dio.dart';
import '../model/single_user_response.dart';
import '../model/user_model.dart';
import '.././http_calls/http_service.dart';
import '.././http_calls/network_exceptions.dart';
import '.././http_calls/api_result.dart';

class APIRepository {
  DioClient dioClient;

  // final String _apiKey = <apikey>;
  String _baseUrl = "https://reqres.in/";

  APIRepository() {
    var dio = Dio();

    dioClient = DioClient(_baseUrl, dio);
  }

  Future<ApiResult<User>> fetchSingleUser() async {
    try {
      final response = await dioClient.get('api/users/2');
      print(response);
      SingleUserResponse _singleUser =
          SingleUserResponse.fromJson(response);
      User user = _singleUser.user;
      return ApiResult.success(data: user);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
