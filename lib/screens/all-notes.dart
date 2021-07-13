import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import "package:intl/intl.dart";
import 'package:mynotes/screens/single-note.dart';

class AllNotes extends StatefulWidget {
  @override
  _AllNotesState createState() => _AllNotesState();
}

class Note {
  int _id;
  String _name;
  String _createdAt;
  String _content;

  Note(this._id, this._name, this._createdAt, this._content);
}

class _AllNotesState extends State<AllNotes> {
  Future<List<Note>> _getNotes() async {
    var url = Uri.parse("https://boiling-sands-85947.herokuapp.com/");
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    List<Note> notes = [];
    for (var i in data) {
      Note note = new Note(i["ID"], i["title"], i["CreatedAt"], i["content"]);
      notes.add(note);
    }

    notes = new List.from(notes.reversed);
    return notes;
  }

  _deleteNote(int id) {
    http.delete(Uri.parse(
        "https://boiling-sands-85947.herokuapp.com/" + id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 70,
        ),
        Center(
          child: Text(
            "My Notes 📝",
            style: GoogleFonts.montserrat(
                textStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 33)),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FutureBuilder(
          future: _getNotes(),
          builder: (context, AsyncSnapshot<List<Note>> snapshot) {
            if (snapshot.data == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 150),
                  Center(
                      child: Text(
                    "Loading..",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(fontSize: 20)),
                  )),
                ],
              );
            } else if (snapshot.data!.length != 0) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                      onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SingleNote(snapshot.data![i]._id)))
                          .then((val) => setState(() {})),
                      child: Dismissible(
                        key: Key(i.toString()),
                        child: Card(
                          margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 15, 18, 0),
                                child: Text(
                                  snapshot.data![i]._name,
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 3, 18, 20),
                                child: Text(
                                  DateFormat.yMMMMEEEEd().format(DateTime.parse(
                                      snapshot.data![i]._createdAt)),
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54)),
                                ),
                              )
                            ],
                          ),
                        ),
                        onDismissed: (direction) =>
                            {_deleteNote(snapshot.data![i]._id)},
                      ));
                },
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 150),
                  Center(
                      child: Text(
                    "Looks like you have no notes.",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(fontSize: 20)),
                  )),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "🗑",
                      style: TextStyle(fontSize: 100),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
