import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class ApprovedDetails extends StatefulWidget {
  @override
  _ApprovedDetailsState createState() => _ApprovedDetailsState();
}

class _ApprovedDetailsState extends State<ApprovedDetails> {
  var totalCash = 0.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final map = ModalRoute.of(context).settings.arguments as Map;
    Stream expenseStream;
    //print(map['date']);

    if (map['type'] == 1) {
      expenseStream = Firestore.instance
          .collection('expenses')
          .where('date', isEqualTo: map['date'])
          .where('status', isEqualTo: 'approved')
          .snapshots();
    } else if (map['type'] == 2) {
      expenseStream = Firestore.instance
          .collection('expenses')
          .where('userName', isEqualTo: map['date'])
          .where('status', isEqualTo: 'approved')
          .snapshots();
    } else if (map['type'] == 3) {
      expenseStream = Firestore.instance
          .collection('expenses')
          .where('supplier', isEqualTo: map['date'])
          .where('status', isEqualTo: 'approved')
          .snapshots();
    } else {
      expenseStream = Firestore.instance
          .collection('expenses')
          .where('status', isEqualTo: 'approved')
          .snapshots();
    }
    return StreamBuilder<QuerySnapshot>(
      stream: expenseStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        final docs = snapshot.data.documents;
        docs.sort((a, b) {
          if (a.data['time'] == null) return -1;
          if (b.data['time'] == null) return 1;
          return (a.data['time'] as Timestamp)
              .compareTo((b.data['time'] as Timestamp));
        });
        docs.forEach((element) {
          final amount = element.data['amount'];
          totalCash += amount;
        });
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
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      'Approved ',
                      style: TextStyle(
                          color: Color.fromRGBO(170, 44, 94, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    trailing: Text('$totalCash EGP',
                        style: TextStyle(
                            color: Color.fromRGBO(170, 44, 94, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      final userName = docs[index].data['userName'];
                      final supplier = docs[index].data['supplier'];
                      final date = docs[index].data['date'];
                      final amount = docs[index].data['amount'];
                      return approvedTile(
                        userName: userName,
                        suplierName: supplier,
                        date: date,
                        amount: amount,
                        documentId: docs[index].documentID,
                      );
                    },
                    itemCount: docs.length,
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigator(),
        );
      },
    );
  }

  approvedTile(
      {String suplierName,
      String userName,
      String date,
      amount,
      String documentId}) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed('/expensesDetails', arguments: {'id': documentId}),
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
