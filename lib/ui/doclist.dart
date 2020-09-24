import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/util/dbhelper.dart';
import '../models/model.dart';
import '../util/utils.dart';
import './docdetails.dart';

// menu item
const menuReset = "Reset Local Data";
List<String> menuOptions = const <String>[
  menuReset
];

class DocList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => DocListState();
}

class DocListState extends State<DocList>{
  DbHelper dbh = DbHelper();
  List <Doc> docs;
  int count = 0;
  DateTime cDate;

  @override
  void inistate(){
    super.initState();
  }
  Future getData()async {
    final dbFuture = dbh.initializeDb();
    dbFuture.then((result) {
      final docsFuture = dbh.getDocs();
      docsFuture.then((result) {
        if (result.length >= 0) {
          List<Doc> docList = List<Doc>();
          var count = result.length;
          for (int i = 0; i <= count - 1; i++) {
            docList.add(Doc.fromObject(result[i]));
          }
          setState(() {
            if (this.docs.length > 0) {
              this.docs.clear();
            }
            this.docs = docList;
            this.count = count;
          });
        }
      });
    });
  }

  void _checkDate(){
    const secs = const Duration(seconds: 10);
    new Timer.periodic(secs, (Timer t) {
      DateTime now = DateTime.now();
      if (cDate.day != now.day || cDate.month != now.month || cDate.year != now.year){
        getData();
        cDate = DateTime.now();
      }
    });
  }
  
  void navigateToDetails(Doc doc) async{
    bool r = await Navigator.push(context, MaterialPageRoute(builder: (context)=> DocDetail(doc))
    );
    if (r == true){
      getData();
    }
  }
  
  void _showResetDialog(){
    showDialog(context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: new Text("Reset"),
        content: new Text("Do you want to delete all the local data?"),
        actions: <Widget>[
          FlatButton(
              child: new Text("Ok"),
              onPressed: (){
                Future future = _resetLocalData();
                future.then((result) {
                  Navigator.of(context).pop();

                }
                );
              },
          ),
        ],
      );
    }
    );
  }
  Future _resetLocalData() async{
    final dbFuture = dbh.initializeDb();
    dbFuture.then((result){
      final dDocs = dbh.deleteRows(DbHelper.tableDocs);
      dDocs.then((result){
        setState(() {
          this.docs.clear();
          this.count = 0;
        });
      });


    });
  }

  void _selectmenu(String value)async{
    switch(value){
      case menuReset: _showResetDialog();
    }
  }

  ListView docListItems(){
    return ListView.builder(
      itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          String dd = Val.GetExpiryString(this.docs[position].expiration);
          String dl = (dd != "1") ? "days left" : " day left";
          return Card(
            color: Colors.white,
            elevation: 1.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                (Val.GetExpiryString(this.docs[position].expiration) != "0") ?
                Colors.blue : Colors.red,
                child: Text(
                  this.docs[position].id.toString(),
                ),
              ),
              title: Text(this.docs[position].title),
              subtitle: Text(
                  Val.GetExpiryString(this.docs[position].expiration) + dl +
                      "\nExp: " + DateUtils.convertToDateFull(
                      this.docs[position].expiration)),
              onTap: () {
                navigateToDetails(this.docs[position]);
              },
            ),
          );
        }
      );
    }

    @override
  Widget build(BuildContext context){
    this.cDate = DateTime.now();
    if (this.docs == null){
      this.docs = List<Doc>();
      getData();
    }
    _checkDate();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("DocExpire"),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: _selectmenu,
              itemBuilder: (BuildContext context){
                return menuOptions.map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                      child: Text(choice),
                  );
                }).toList();
              },
              ),
        ],
      ),
      body: Center(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              docListItems(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              navigateToDetails(Doc.withId(-1, "", "", 1, 1, 1));
            },
            tooltip: "Add new doc",
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
    }
}