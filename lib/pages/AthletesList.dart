import 'package:ae_dapp/pages/AthletesDetail.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/service/Athlete.dart';

class AthletesList extends StatefulWidget {
  @override
  _AllAthletesListState createState() => _AllAthletesListState();
}

class _AllAthletesListState extends State<AthletesList> {
  List<Athlete> _AllAthletesList = <Athlete>[]; //All athletes
  List<Athlete> returnableListData = <Athlete>[];

  final TextEditingController _filter = new TextEditingController(); //
  Widget _appBarTitle = new Text('My Team');
  List filteredNames = <Athlete>[]; // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  final _boughtAthletes = <Athlete>{};
  Future<dynamic>? _loadData;
  String _searchText = "";

  @override
  void initState() {
    // TODO: implement initState
    //
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          updateFilter(_searchText);
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          updateFilter(_searchText);
        });
      }
    });
    _loadData = _loadAthletes();
    super.initState();
  }

  void updateFilter(String text) {
    print("updated Text: $text");
  }

  Future<dynamic> _loadAthletes() async {
    return await fetchAthletes();
  }

/*
  void _searchPressed(String title) {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          style: setTextStyle(),
          controller: _filter,
          decoration: new InputDecoration(
              // Probably need to abstract this out later - vx for search
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              prefixIcon: new Icon(
                Icons.search,
                color: Colors.black,
              ),
              hintText: 'Search...',
              hintStyle: setTextStyle()),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(title);
        _filter.clear();
        this._appBarTitle = null;
      }
    });
  }
  */

  setTextStyle() {
    return TextStyle(color: Colors.blueGrey);
  }

  searchFilter(int i) {
    //     if (_athletesSearchableList[i]
    //     .name
    //     .toLowerCase()
    //     .contains(_searchText.toLowerCase())) {
    //   _athleteFilteredList.add(_athletesSearchableList[i]);
    // }
  }

  void _AthleteDetails(Athlete aAthlete) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("About ${aAthlete.name}"),
          ),
          body: AthleteDetail(),
        );
      }),
    );
  }

  Widget _buildAthletes(AsyncSnapshot<dynamic> snapshot) {
    _AllAthletesList.addAll(snapshot.data!);

    return ListView.builder(
      itemCount: _AllAthletesList.length,
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        if (index.isOdd) return Divider(); /*2*/
        final i = index ~/ 2; // i is every even item in this iteration
        return _buildRow(_AllAthletesList[i]);
      },
    );
  }

  Widget _buildRow(Athlete a) {
    final alreadyBought = _boughtAthletes.contains(a);

    return Card(
      color: Colors.blueAccent,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.sports_baseball_rounded,
              color: Colors.yellow[760],
            ),
            title: Text(a.name ?? ""),
            subtitle: Text("Buy: ${a.warValue}"),
            trailing: alreadyBought
                ? Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                  )
                : Icon(Icons.check_circle_outline),
            onTap: () {
              setState(() {
                _AthleteDetails(a);
                if (alreadyBought) {
                  _boughtAthletes.remove(a);
                } else {
                  _boughtAthletes.add(a);
                }
              });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle == null ? Text("Buy an Athlete") : _appBarTitle,
        elevation: 2,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: _searchIcon,
              onPressed: () {
  //              _searchPressed("Search an Athlete");
              })
        ],
      ),
      body: FutureBuilder<dynamic>(
              future: _loadData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: () {
                      return _loadData = fetchAthletes();
                    },
                    child: Center(
                      child: _buildAthletes(snapshot),
                    )
                  );
                } else if (snapshot.hasError) {
                  return Text(
                      "Something went wrong! make sure you're connected to the internet");
                }
                return CircularProgressIndicator(
                  backgroundColor: Colors.yellowAccent,
                );
              },
            ),
    );
  }
}