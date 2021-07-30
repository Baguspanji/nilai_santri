import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nilai_santri/src/helper/widgetUI.dart';
import 'package:nilai_santri/src/model/santriModel.dart';
import 'package:nilai_santri/src/ui/homeUI.dart';

class EditUI extends StatefulWidget {
  final String uid;
  const EditUI({Key key, this.uid}) : super(key: key);

  @override
  _EditUIState createState() => _EditUIState();
}

class _EditUIState extends State<EditUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  final database = FirebaseDatabase.instance.reference();

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController alamatController = TextEditingController();

  String _dropdownValue = 'Pilih Kelas';

  void readSantri() {
    database.child("santri").child(widget.uid).once().then((value) {
      final item = GetSantri.fromSnapshot(value);
      idController.text = item.id_santri;
      nameController.text = item.nama_santri;
      alamatController.text = item.alamat_santri;
      _dropdownValue = item.kelas_santri;
      setState(() {});
    });
  }

  void _editData() async {
    if (idController.text != '' ||
        nameController.text != '' ||
        alamatController.text != '' ||
        _dropdownValue != 'Pilih Kelas') {
      database.child('santri').child(widget.uid).update({
        'id_santri': idController.text,
        'nama_santri': nameController.text,
        'alamat_santri': alamatController.text,
        'kelas_santri': _dropdownValue,
      }).then((value) {
        Navigator.pop(context);
      });
    } else {
      showInSnackBar("Form tidak boleh kosong!");
    }
  }

  @override
  void initState() {
    super.initState();
    readSantri();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text("Edit Santri"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Edit Santri",
              style: tstyle(30, weight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            buildInput(_size, idController, "Masukkan NIS",
                tipe: TextInputType.number),
            buildInput(_size, nameController, "Masukkan Nama"),
            buildInput(_size, alamatController, "Masukkan Alamat"),
            buildDropdown(_size),
            Container(
              width: _size.width * 0.6,
              height: 50,
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () => _editData(),
                child: Text("Update", style: tstyle(20, color: Colors.white)),
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

  Container buildInput(
      Size _size, TextEditingController controller, String placeholder,
      {TextInputType tipe = TextInputType.text}) {
    return Container(
      width: _size.width * 0.7,
      height: 60,
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
      width: size.width * 0.7,
      height: 60,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(width: 1, color: Colors.grey[500]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: _dropdownValue,
        elevation: 16,
        style: const TextStyle(color: Colors.black38),
        onChanged: (String newValue) {
          setState(() {
            _dropdownValue = newValue;
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
                style: tstyle(16, color: Colors.black38),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
