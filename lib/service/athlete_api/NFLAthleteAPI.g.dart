// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NFLAthleteAPI.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _NFLAthleteAPI implements NFLAthleteAPI {
  _NFLAthleteAPI(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://db.athletex.io/nfl';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<NFLAthlete>> getAllPlayers() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<NFLAthlete>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/players',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => NFLAthlete.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<NFLAthlete>> getPlayersById(idsDict) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(idsDict);
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<NFLAthlete>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/players',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => NFLAthlete.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
