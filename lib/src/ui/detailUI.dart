import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nilai_santri/src/helper/widgetUI.dart';
import 'package:nilai_santri/src/model/santriModel.dart';
import 'package:nilai_santri/src/ui/editUI.dart';
import 'package:nilai_santri/src/ui/homeUI.dart';
import 'package:nilai_santri/src/ui/nilaiUI.dart';
import 'package:nilai_santri/src/ui/riwayatUI.dart';

class DetailUI extends StatefulWidget {
  final String id;
  const DetailUI({Key key, this.id}) : super(key: key);

  @override
  _DetailUIState createState() => _DetailUIState();
}

class _DetailUIState extends State<DetailUI> {
  final database = FirebaseDatabase.instance.reference();

  List<GetSantri> _items = List();

  String id = '';
  String nama = '';
  String alamat = '';
  String kelas = '';
  String uid = '';

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  void dispose() {
    _items.clear();
    super.dispose();
  }

  void readData() {
    database.child("santri").onChildAdded.listen((event) {
      _items.add(new GetSantri.fromSnapshot(event.snapshot));

      for (var item in _items.where((e) => e.id_santri == widget.id)) {
        // print(item.id_santri + ':' + item.nama_santri);
        id = item.id_santri;
        nama = item.nama_santri;
        alamat = item.alamat_santri;
        kelas = item.kelas_santri;
        uid = item.key;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text("Detail Santri"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 30),
        alignment: Alignment.center,
        child: Column(
          children: [
            buildDetail(_size, id),
            buildDetail(_size, nama),
            buildDetail(_size, alamat),
            buildDetail(_size, kelas),
            Container(
              width: _size.width * 0.6,
              height: 50,
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NIlaiUI(id: id),
                  ),
                ),
                child: Text(
                  "Tambah Nilai",
                  style: tstyle(20, color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: _size.width * 0.6,
              height: 50,
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RiwayatUI(
                      uid: uid,
                    ),
                  ),
                ),
                child: Text(
                  "Riwayat Nilai",
                  style: tstyle(20, color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: _size.width * 0.6,
              height: 50,
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUI(
                      uid: uid,
                    ),
                  ),
                ),
                child: Text(
                  "Edit Santri",
                  style: tstyle(20, color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: _size.width * 0.6,
              height: 50,
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () => delete(),
                child: Text(
                  "Hapus Santri",
                  style: tstyle(20, color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildDetail(Size _size, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      alignment: Alignment.centerLeft,
      width: _size.width * 0.8,
      height: _size.height * 0.08,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.greenAccent, width: 2),
      ),
      child: Text(
        '${value}',
        style: tstyle(22),
      ),
    );
  }

  void delete() {
    database.child("santri").child(uid).remove().then(
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeUI(),
            ),
          ),
        );
  }
}
