import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class OnDistributionType extends StatefulWidget {
  @override
  _OnDistributionState createState() => _OnDistributionState();
}

class _OnDistributionState extends State<OnDistributionType> {
  List<String> dates = [];
  List<String> person = [];
  List<String> area = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        bottomNavigationBar: BottomNavigator(),
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 10,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Image.asset(
            'assets/images/logo.png',
            width: 150,
          ),
        ),
        body: Column(children: [
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Image.asset('assets/images/NotApproved.png'),
              title: Text(
                'On Distribution Route',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
                future: Firestore.instance
                    .collection('routes')
                    .where('status', isEqualTo: 'onDistribution')
                    .getDocuments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  final documents = snapshot.data.documents;
                  documents.sort((a, b) => (a.data['time'] as Timestamp)
                      .compareTo((b.data['time'] as Timestamp)));
                  documents.forEach((element) {
                    if (!dates.contains(element.data['date']))
                      dates.add(element.data['date']);
                    if (!person.contains(element.data['name']))
                      person.add(element.data['name']);
                    if (!area.contains(element.data['area']))
                      area.add(element.data['area']);
                  });
                  print('dates:$dates');
                  print('person:$person');
                  print('area:$area');
                  return ListView(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed('/dateScreen', arguments: {
                                'route': '/onDistributionRoutes',
                                'date': dates,
                                'type': 1,
                                'logo': 'assets/images/DateIcon.png',
                                'title': 'Date',
                              }),
                              child: Container(
                                width: size.width / 2.25,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2.5, color: Colors.grey[400]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                          'assets/images/DateIcon.png'),
                                      width: 100,
                                      height: 100,
                                    ),
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(134, 134, 134, 1),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed('/dateScreen', arguments: {
                                'route': '/onDistributionRoutes',
                                'date': person,
                                'type': 2,
                                'logo': 'assets/images/Person.png',
                                'title': 'Person',
                              }),
                              child: Container(
                                width: size.width / 2.25,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2.5, color: Colors.grey[400]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                        'assets/images/Person.png',
                                      ),
                                      width: 100,
                                      height: 100,
                                    ),
                                    Text(
                                      'Person',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(134, 134, 134, 1),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed('/dateScreen', arguments: {
                                'route': '/onDistributionRoutes',
                                'date': area,
                                'type': 3,
                                'logo': 'assets/images/LineIcon.png',
                                'title': 'Area',
                              }),
                              child: Container(
                                width: size.width / 2.25,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2.5, color: Colors.grey[400]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                          'assets/images/LineIcon.png'),
                                      width: 100,
                                      height: 100,
                                    ),
                                    Text(
                                      'Area',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(134, 134, 134, 1),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed('/onDistributionRoutes'),
                              child: Container(
                                width: size.width / 2.25,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2.5, color: Colors.grey[400]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                          'assets/images/AllIcon.png'),
                                      width: 100,
                                      height: 100,
                                    ),
                                    Text(
                                      'All',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(134, 134, 134, 1),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ]));
  }
}
