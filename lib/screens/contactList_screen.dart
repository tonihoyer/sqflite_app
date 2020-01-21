import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite_app/database/DBHelper.dart';
import 'package:sqflite_app/model/Contacts.dart';
import 'package:sqflite_app/screens/add_contact.dart';

Future<List<Contacts>> getContactsFromDB() async {
  var dbHelper = DBHelper();
  Future<List<Contacts>> contacts = dbHelper.getContacts();
  return contacts;
}

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final controller_name = new TextEditingController();
  final controller_phone = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kontaktliste"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                icon: Icon(Icons.control_point),
                iconSize: 35,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Homescreen()));
                }),
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder<List<Contacts>>(
            future: getContactsFromDB(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    snapshot.data[index].phone,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Kontaktdaten ändern
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    content: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                TextFormField(
                                                  autofocus: true,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          '${snapshot.data[index].name}'),
                                                  controller: controller_name,
                                                ),
                                                TextFormField(
                                                  autofocus: true,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          '${snapshot.data[index].phone}'),
                                                  controller: controller_phone,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      //Änderung abbrechen
                                      FlatButton(
                                        child: Text("Abbrechen",
                                            style: TextStyle(fontSize: 18)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      //Änderung speichern
                                      FlatButton(
                                        child: Text("Ändern",
                                            style: TextStyle(fontSize: 18)),
                                        onPressed: () {
                                          var dbHelper = DBHelper();
                                          Contacts contact = Contacts();
                                          contact.id = snapshot.data[index].id;
                                          contact.name =
                                              controller_name.text != ''
                                                  ? controller_name.text
                                                  : snapshot.data[index].name;
                                          contact.phone =
                                              controller_phone.text != ''
                                                  ? controller_phone.text
                                                  : snapshot.data[index].phone;

                                          dbHelper.updateContact(contact);
                                          Navigator.pop(context);
                                          setState(() {
                                            getContactsFromDB();
                                          });
                                          Fluttertoast.showToast(
                                              msg: "Kontakt wurde geändert",
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor:
                                                  Color (0xFFb6cfde),
                                              textColor: Color(0xFF333333));
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Icon(
                                  Icons.update,
                                  color: Colors.blueGrey,
                                  size: 28,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                var dbHelper = DBHelper();
                                dbHelper.deleteContact(snapshot.data[index]);
                                setState(() {
                                  getContactsFromDB();
                                });
                                Fluttertoast.showToast(
                                    msg: "Kontakt wurde gelöscht",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Color (0xFFb6cfde),
                                    textColor: Color(0xFF333333));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.blueGrey[800],
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                }
              }

              return Container(
                alignment: AlignmentDirectional.center,
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
