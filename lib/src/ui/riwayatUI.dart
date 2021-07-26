import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:nilai_santri/src/model/santriModel.dart';

class RiwayatUI extends StatefulWidget {
  final String uid;
  const RiwayatUI({Key key, this.uid}) : super(key: key);

  @override
  _RiwayatUIState createState() => _RiwayatUIState();
}

class _RiwayatUIState extends State<RiwayatUI> {
  final database = FirebaseDatabase.instance.reference();

  List<GetNilai> _nilai = List();

  void readNilai() {
    _nilai.clear();
    database
        .child("santri")
        .child(widget.uid)
        .child('nilai_santri')
        .onChildAdded
        .listen((event) {
      _nilai.add(new GetNilai.fromSnapshot(event.snapshot));
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    readNilai();
  }

  @override
  void dispose() {
    _nilai.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text("Riwayat Nilai"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(top: 20),
          width: _size.width * 0.9,
          height: _size.height * 0.8,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 2),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 2, color: Colors.grey))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildContainer(_size, 'Tanggal'),
                    buildContainer(_size, 'Kelas'),
                    buildContainer(_size, 'Keterangan'),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _nilai.length,
                  itemBuilder: (context, i) {
                    final _item = _nilai[i];
                    return InkWell(
                      onTap: () => showAlertDialog(context, _item.catatan),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildContainer(_size, '${_item.tgl}'),
                            buildContainer(_size, '${_item.kelas}'),
                            buildContainer(_size, '${_item.ket}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildContainer(Size _size, String value) {
    return Container(
      alignment: Alignment.center,
      width: _size.width * 0.24,
      child: Text(value),
    );
  }

  showAlertDialog(BuildContext context, String catatan) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Catatan"),
      content: Text('${catatan}'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
