import 'package:flutter/material.dart';
import 'package:flutter_dio_pacakge/repos/api_repo.dart';
import 'http_calls/API_RESULTS/api_result.dart';
import 'http_calls/NETWORK_EXCEPTIONS/network_exceptions.dart';
import 'http_calls/RESULT_STATE/result_state.dart';
import 'model/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  APIRepository _apiRepository = APIRepository();
  ResultState<User> state = ResultState.loading();

  Future getUsers() async {
    ApiResult<User> apiResult = await _apiRepository.fetchSingleUser();

    apiResult.when(success: (User user) {
      setState(() {
        state = ResultState.data(data: user);
      });
    }, failure: (NetworkExceptions error) {
      print(error.toString());
      setState(() {
        state = ResultState.error(error: error);
      });
    });
    return state;
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: state.when(
            idle: () => Container(),
            loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
            data: (User data) {
              return Center(
                child: Text(data.email),
              );
            },
            error: (NetworkExceptions error) {
              return Text(NetworkExceptions.getErrorMessage(error));
            }),
      ),
    );
  }
}
