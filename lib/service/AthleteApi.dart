import 'package:flutter/material.dart';
import 'package:ax_dapp/service/athleteModels/NFLAthlete.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AthleteApi {
  static final String _baseURL = 'https://db.athletex.io';
  // static final String _baseURL = 'http://139.99.74.201:8080';

  static final int mStaffordId = 9038;
  static final int jChaseId = 22564;
  static final int jBurrowId = 21693;
  static final int cKuppId = 18882;
  static Future<List<NFLAthlete>> getAthletesLocally(
      BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/data.json');
    final body = json.decode(data);
    //print(body);
    return body.map<NFLAthlete>(NFLAthlete.fromJsonStatic).toList();
  }

  static List<NFLAthlete> parseAthletes(var athleteResponse) {
    final parsed = json.decode(athleteResponse).cast<Map<String, dynamic>>();
    return parsed
        .map<NFLAthlete>((json) => NFLAthlete.fromJsonStatic(json))
        .toList();
  }

  static Future<List<NFLAthlete>> getAthletesFromIdList(
      BuildContext context) async {
    List<String> athleteIDs = [
      mStaffordId.toString(),
      jChaseId.toString(),
      jBurrowId.toString(),
      cKuppId.toString()
    ];
    final List<NFLAthlete> athletesList = [];
    for (String id in athleteIDs) {
      final athleteResponse =
          await http.get(Uri.parse('$_baseURL/nfl/players/$id'));

      print(athleteResponse.statusCode);

      if (athleteResponse.statusCode == 200) {
        var athlete =
            NFLAthlete.fromJsonStatic(jsonDecode(athleteResponse.body));
        athletesList.add(athlete);
      } else {
        throw Exception("Failed to load athlete");
      }
    }
    print(athletesList);
    return athletesList;
  }

  static Future<List<NFLAthlete>> getAthletesFromIdsDict(
      BuildContext context) async {
    Map<String, List<int>> athleteIdDict = {
      "ids": [mStaffordId, jChaseId, jBurrowId, cKuppId],
    };
    final jsonRequestBody = json.encode(athleteIdDict);
    print(jsonRequestBody);

    final uri = Uri.parse('$_baseURL/nfl/players');
    final athleteResponse = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: jsonRequestBody);
    print(athleteResponse.statusCode);

    if (athleteResponse.statusCode == 200) {
      var athleteResponseList = jsonDecode(athleteResponse.body) as List;
      return athleteResponseList
          .map((athlete) => NFLAthlete.fromJsonStatic(athlete))
          .toList();
    } else {
      throw Exception("Failed to load athlete");
    }
  }
}
