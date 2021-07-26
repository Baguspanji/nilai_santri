import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:nilai_santri/src/helper/widgetUI.dart';
import 'package:nilai_santri/src/model/santriModel.dart';
import 'package:nilai_santri/src/ui/addUI.dart';
import 'package:nilai_santri/src/ui/detailUI.dart';
import 'package:nilai_santri/src/ui/loginUI.dart';
import 'package:nilai_santri/src/ui/qrUI.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({Key key}) : super(key: key);

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  final database = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> _santriSubscription;
  List<GetSantri> _items = List();
  bool _anchorToBottom = false;
  DatabaseReference _santriRef;

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  void dispose() {
    super.dispose();
    _items.clear();
    _santriSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
              child: Icon(Icons.logout_rounded, size: 32),
            ),
            Text("Daftar Santri"),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUI(),
                ),
              ),
              child: Icon(Icons.post_add_outlined, size: 32),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          readData();
        },
        child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, i) {
              final item = _items[i];
              return buildSantri(
                _size,
                item.key,
                item.id_santri,
                item.nama_santri,
                item.kelas_santri,
                item.alamat_santri,
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QrUI(),
          ),
        ),
        child: Icon(Icons.qr_code),
        backgroundColor: Colors.green.shade400,
      ),
    );
  }

  InkWell buildSantri(Size _size, String _key, String _id, String _nama,
      String _kelas, String _alamat) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailUI(id: _id),
        ),
      ),
      child: Container(
        width: _size.width * 0.9,
        height: _size.height * 0.17,
        padding: EdgeInsets.all(14),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.greenAccent, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_id',
                  style: tstyle(20),
                ),
                Text(_kelas),
              ],
            ),
            Text(
              _nama,
              style: tstyle(24),
            ),
            Text(
              _alamat,
              style: tstyle(18),
            ),
          ],
        ),
      ),
    );
  }

  void readData() {
    _items.clear();

    _santriRef = database.child("santri");
    // .orderByChild("member/sampai")
    // .startAt(DateTime.now().toString())
    _santriRef.onChildAdded.listen(_onSatri);
    return;
  }

  void _onSatri(Event event) {
    setState(() {
      _items.add(new GetSantri.fromSnapshot(event.snapshot));
      _items.sort((a, b) => a.id_santri.compareTo(b.id_santri));
      // _items.sort((e, f) => f.sampai.compareTo(DateTime.now()));
    });
  }
}
