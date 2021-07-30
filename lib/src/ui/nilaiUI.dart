import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nilai_santri/src/helper/widgetUI.dart';
import 'package:nilai_santri/src/model/santriModel.dart';
import 'package:intl/intl.dart';

class NIlaiUI extends StatefulWidget {
  final String id;
  const NIlaiUI({Key key, this.id}) : super(key: key);

  @override
  _NIlaiUIState createState() => _NIlaiUIState();
}

class _NIlaiUIState extends State<NIlaiUI> {
  final database = FirebaseDatabase.instance.reference();
  TextEditingController catatan = TextEditingController();
  List<GetSantri> _items = List();

  String nama = '';
  String kelas = '';
  String uid = '';
  String _dropdownValue = 'Pilih Penilaian';
  String _dropdownKelas = 'Pilih Kelas';
  DateTime now = DateTime.now();

  void readData() {
    database.child("santri").onChildAdded.listen((event) {
      _items.add(new GetSantri.fromSnapshot(event.snapshot));

      for (var item in _items.where((e) => e.id_santri == widget.id)) {
        print(item.id_santri + ':' + item.nama_santri);
        nama = item.nama_santri;
        kelas = item.kelas_santri;
        uid = item.key;
      }
      setState(() {});
    });
  }

  void _niliaOrder() {
    var data = {
      'tgl': DateFormat('yyyy-MM-dd').format(now),
      'ket': _dropdownValue,
      'kelas': kelas,
      'catatan': catatan.text
    };
    database
        .child('santri')
        .child(uid)
        .child('nilai_santri')
        .push()
        .set(data)
        .then((value) => Navigator.pop(context));
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text("Nilai"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            buildDetail(_size, widget.id),
            buildDetail(_size, nama),
            buildDetail(_size, kelas),
            buildDropdown(_size),
            buildInput(_size, catatan, "Masukkan catatan"),
            Container(
              width: _size.width * 0.6,
              height: 50,
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () => _niliaOrder(),
                child: Text("Nilai", style: tstyle(20, color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black),
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
      alignment: Alignment.center,
      width: _size.width * 0.8,
      height: _size.height * 0.08,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Text(
        '${value}',
        style: tstyle(22),
      ),
    );
  }

  Container buildInput(
      Size _size, TextEditingController controller, String placeholder,
      {TextInputType tipe = TextInputType.text}) {
    return Container(
      width: _size.width * 0.8,
      height: _size.height * 0.1,
      margin: EdgeInsets.only(top: 10),
      child: TextField(
        controller: controller,
        keyboardType: tipe,
        decoration: new InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(12),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(12),
            ),
            borderSide: BorderSide(color: Colors.green.shade400),
          ),
          filled: true,
          hintStyle: new TextStyle(color: Colors.black38),
          hintText: placeholder,
          fillColor: Colors.white70,
        ),
      ),
    );
  }

  Container buildDropdown(Size size) {
    return Container(
      alignment: Alignment.center,
      width: size.width * 0.8,
      height: size.height * 0.08,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<String>(
        value: _dropdownValue,
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        onChanged: (String newValue) {
          setState(() {
            _dropdownValue = newValue;
          });
        },
        items: <String>[
          'Pilih Penilaian',
          'Lulus',
          'Tidak Lulus',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              width: size.width * 0.6,
              child: Text(
                value,
                style: tstyle(16, color: Colors.black),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Container buildDropdownKelas(Size size) {
    return Container(
      alignment: Alignment.center,
      width: size.width * 0.8,
      height: size.height * 0.08,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<String>(
        value: _dropdownKelas,
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        onChanged: (String newValue) {
          setState(() {
            _dropdownKelas = newValue;
          });
        },
        items: <String>[
          'Pilih Kelas',
          'Jilid 1',
          'Jilid 2',
          'Jilid 3',
          'Jilid 4',
          'Jilid 5',
          'Jilid 6',
          'Juz 27',
          'Al-Quran',
          'Ghorib',
          'Tajwid',
          'Finishing'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              width: size.width * 0.6,
              child: Text(
                value,
                style: tstyle(16, color: Colors.black),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
