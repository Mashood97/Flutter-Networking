import 'package:flutter/material.dart';
import 'package:flutter_dio_pacakge/repos/api_repo.dart';
import 'http_calls/API_RESULTS/api_result.dart';
import 'http_calls/NETWORK_EXCEPTIONS/network_exceptions.dart';
import 'http_calls/RESULT_STATE/result_state.dart';
import 'model/list_user_response.dart';
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
      home: ListUser(),
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

  Future getUser() async {
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
    getUser();
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

class ListUser extends StatefulWidget {
  @override
  _ListUserState createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  APIRepository _apiRepository = APIRepository();
  ResultState<ListUserResponse> state = ResultState.loading();
  ResultState<bool> boolstate = ResultState.loading();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  Future getUsers() async {
    ApiResult<ListUserResponse> apiResult =
        await _apiRepository.fetchListOfUser();

    apiResult.when(success: (ListUserResponse user) {
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

  Future deleteUser(int userId) async {
    ApiResult<bool> apiResult = await _apiRepository.deleteUser(userId);

    apiResult.when(success: (bool user) {
      setState(() {
        boolstate = ResultState.data(data: user);
      });
    }, failure: (NetworkExceptions error) {
      print(error.toString());
      setState(() {
        boolstate = ResultState.error(error: error);
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
      key: _scaffoldkey,
      body: SafeArea(
        child: state.when(
            idle: () => Container(),
            loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
            data: (ListUserResponse data) {
              return ListView.separated(
                itemCount: data.user.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (ctx, index) => Dismissible(
                  key: ValueKey(data.user[index].id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      // dismissed to the left
                      await deleteUser(data.user[index].id);
                      data.user.removeAt(index);
                      SnackBar snackBar = SnackBar(
                        content: Text('Deleted Successfully'),
                      );
                      _scaffoldkey.currentState.showSnackBar(snackBar);
                    }
                  },
                  direction: DismissDirection.startToEnd,
                  child: ListTile(
                      title: Text(data.user[index].first_name.toString()),
                      subtitle: Text(data.user[index].email.toString()),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          data.user[index].avatar,
                        ),
                        radius: 30,
                      )),
                ),
              );
            },
            error: (NetworkExceptions error) {
              return Text(NetworkExceptions.getErrorMessage(error));
            }),
      ),
    );
  }
}
