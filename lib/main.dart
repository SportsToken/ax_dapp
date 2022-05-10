import 'package:ax_dapp/pages/LandingPage.dart';
import 'package:ax_dapp/repositories/MlbRepo.dart';
import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:ax_dapp/repositories/usecases/GetPairInfoUseCase.dart';
import 'package:ax_dapp/service/Api/MLBAthleteAPI.dart';
import 'package:ax_dapp/service/GraphQL/GraphQLClientHelper.dart';
import 'package:ax_dapp/service/GraphQL/GraphQLConfiguration.dart';
import 'package:ax_dapp/service/athlete_api/MLBAthleteAPI.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final _dio = Dio();
final _mlbApi = MLBAthleteAPI(_dio);
final _graphQLClientHelper =
    GraphQLClientHelper(GraphQLConfiguration.athleteDexApiLink);
void main() async {
  final _gQLClient = await _graphQLClientHelper.initializeClient();
  final _subGraphRepo = SubGraphRepo(_gQLClient.value);

  print("Graph QL CLient initialized}");
  runApp(GraphQLProvider(
    client: _gQLClient,
    child: MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => MLBRepo(_mlbApi),
        ),
        RepositoryProvider(create: (context) => _subGraphRepo),
        RepositoryProvider(
            create: (context) => GetPairInfoUseCase(_subGraphRepo))
      ],
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Returns anything!
    return MaterialApp(
      title: "AthleteX",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      theme: ThemeData(
          canvasColor: Colors.transparent,
          brightness: Brightness.dark,
          primaryColor: Colors.yellow[700],
          colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
              .copyWith(secondary: Colors.black)),
      home: LandingPage(),
      // home: V1App(),
      // home: HomePage()
    );
  }
}
