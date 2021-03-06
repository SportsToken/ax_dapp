import 'package:ax_dapp/service/athlete_models/sport_athlete.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nfl_athlete.g.dart';

@JsonSerializable()
class NFLAthlete extends SportAthlete {
  const NFLAthlete({
    required int id,
    required String name,
    required String team,
    required String position,
    required this.passingYards,
    required this.passingTouchDowns,
    required this.reception,
    required this.receiveYards,
    required this.receiveTouch,
    required this.rushingYards,
    required this.offensiveSnapsPlayed,
    required this.defensiveSnapsPlayed,
    required double price,
    required String timeStamp,
  }) : super(id, name, team, position, price, timeStamp);

  factory NFLAthlete.fromJson(Map<String, dynamic> json) =>
      _$NFLAthleteFromJson(json);

  @JsonKey(name: 'passingYards')
  final double passingYards;
  @JsonKey(name: 'passingTouchDowns')
  final double passingTouchDowns;
  @JsonKey(name: 'reception')
  final double reception;
  @JsonKey(name: 'receiveYards')
  final double receiveYards;
  @JsonKey(name: 'receiveTouch')
  final double receiveTouch;
  @JsonKey(name: 'rushingYards')
  final double rushingYards;
  @JsonKey(name: 'OffensiveSnapsPlayed')
  final double offensiveSnapsPlayed;
  @JsonKey(name: 'DefensiveSnapsPlayed')
  final double defensiveSnapsPlayed;

  Map<String, dynamic> toJson() => _$NFLAthleteToJson(this);
}
