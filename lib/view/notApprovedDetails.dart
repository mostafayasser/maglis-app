import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotApprovedDetails extends StatefulWidget {
  @override
  _ApprovedDetailsState createState() => _ApprovedDetailsState();
}

class _ApprovedDetailsState extends State<NotApprovedDetails> {
  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context).settings.arguments as Map;
    Stream revenuetream;

    if (map != null) {
      if (map['type'] == 1) {
        revenuetream = Firestore.instance
            .collection('revenue')
            .where('date', isEqualTo: map['date'])
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      } else if (map['type'] == 2) {
        revenuetream = Firestore.instance
            .collection('revenue')
            .where('userName', isEqualTo: map['date'])
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      } else if (map['type'] == 3) {
        print('cairo');
        revenuetream = Firestore.instance
            .collection('revenue')
            .where('isCairo', isEqualTo: true)
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      } else if (map['type'] == 4) {
        print('Cities');
        revenuetream = Firestore.instance
            .collection('revenue')
            .where('isCairo', isEqualTo: false)
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      } else {
        revenuetream = Firestore.instance
            .collection('revenue')
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      }
    } else {
      revenuetream = Firestore.instance
          .collection('revenue')
          .where('status', isEqualTo: 'notApproved')
          .snapshots();
    }
    return Scaffold(
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
        body: Container(
            child: ListView(children: [
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              title: Text(
                'Not Approved',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: revenuetream,
              builder: (context, snapshot) {
                return ListView.builder(
                  itemBuilder: (ctx, index) {
                    print(index);
                    final userName =
                        snapshot.data.documents[index].data['userName'];
                    final supplier =
                        snapshot.data.documents[index].data['supplier'];
                    final date = snapshot.data.documents[index].data['date'];
                    final amount =
                        snapshot.data.documents[index].data['amount'];
                    return approvedTile(supplier, userName, date, amount,
                        snapshot.data.documents[index].documentID);
                  },
                  itemCount: snapshot.data.documents.length,
                );
              })
        ])));
  }

  approvedTile(String suplierName, String userName, Timestamp itemStamp, amount,
      String id) {
    DateTime itemDate = itemStamp.toDate();
    String date = DateFormat.yMd().format(itemDate);
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed('/expensesDetails', arguments: {'id': id}),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 2.5,
              color: Color.fromRGBO(170, 44, 94, 1),
            ),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: RichText(
                        text: TextSpan(
                      text: "${suplierName}\n",
                      children: [
                        TextSpan(
                          text: '${userName}\n',
                          style: TextStyle(
                            color: Color.fromRGBO(96, 125, 129, 1),
                          ),
                        ),
                        TextSpan(
                          text: '${date}',
                          style: TextStyle(
                              color: Color.fromRGBO(96, 125, 129, 1),
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(170, 44, 94, 1)),
                    )),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '${amount} EGP',
                            style: TextStyle(
                                color: Color.fromRGBO(170, 44, 94, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Color.fromRGBO(170, 44, 94, 1),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "ADD",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(170, 44, 94, 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
