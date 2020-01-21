import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite_app/database/DBHelper.dart';
import 'package:sqflite_app/model/Contacts.dart';
import 'package:sqflite_app/screens/contactList_screen.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Contacts contact = new Contacts();
  String name;
  String phone;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("neuer Kontakt"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "Name"),
                    validator: (val) =>
                        val.length == 0 ? "Name eintragen" : null,
                    onSaved: (val) => this.name = val,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "Nummer"),
                    validator: (val) =>
                        val.length == 0 ? "Nummer eintragen" : null,
                    onSaved: (val) => this.phone = val,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    onPressed: submitContact,
                    child: Text("Kontakt hinzufügen"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void startContactList() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ContactList()));
  }

  void submitContact() {
    if(this.formKey.currentState.validate()){
      formKey.currentState.save();
      Navigator.push(context, MaterialPageRoute(builder: (context) => ContactList()));
    }else{
      return null;
    }

    var contact = Contacts();
    contact.name = name;
    contact.phone = phone;

    var dbHelper = DBHelper();
    dbHelper.addNewContact(contact);
    Fluttertoast.showToast(
      msg: "Kontakt wurde gespeichert",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Color (0xFFb6cfde),
      textColor: Color (0xFF333333)
    );
  }
}
