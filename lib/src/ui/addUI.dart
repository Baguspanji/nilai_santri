import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nilai_santri/src/helper/widgetUI.dart';
import 'package:nilai_santri/src/ui/homeUI.dart';

class AddUI extends StatefulWidget {
  const AddUI({Key key}) : super(key: key);

  @override
  _AddUIState createState() => _AddUIState();
}

class _AddUIState extends State<AddUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  final database = FirebaseDatabase.instance.reference();

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController waController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();

  String _dropdownValue = 'Pilih Kelas';

  void _addData() async {
    if (idController.text != '' ||
        nameController.text != '' ||
        alamatController.text != '' ||
        _dropdownValue != 'Pilih Kelas' ||
        waController.text != '') {
      if (waController.text[0] != '0') {
        showInSnackBar("Masukkan nomor dengan benar");
      } else {
        database.child('santri').push().set({
          'id_santri': idController.text,
          'nama_santri': nameController.text,
          'alamat_santri': alamatController.text,
          'kelas_santri': _dropdownValue,
          'noWa': waController.text,
          'latitude': latController.text,
          'longitude': longController.text,
          'nilai_santri': [],
        }).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeUI(),
            ),
          );
        });
      }
    } else {
      showInSnackBar("Form tidak boleh kosong!");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: appBar(),
      body: body(_size),
    );
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.green[400],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Add Santri"),
          InkWell(
            onTap: () {},
            child: Icon(Icons.post_add_outlined, size: 32),
          ),
        ],
      ),
    );
  }

  Widget body(Size _size) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Tambah Santri",
            style: tstyle(30, weight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          buildInput(_size, idController, "Masukkan NIS",
              tipe: TextInputType.number),
          buildInput(_size, nameController, "Masukkan Nama"),
          buildInput(_size, alamatController, "Masukkan Alamat"),
          buildDropdown(_size),
          buildInput(_size, waController, "081xxx", tipe: TextInputType.phone),
          buildInput(_size, latController, "Masukkan Latitude",
              tipe: TextInputType.phone),
          buildInput(_size, longController, "Masukkan Longitude",
              tipe: TextInputType.phone),
          Container(
            width: _size.width * 0.6,
            height: 50,
            margin: EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () => _addData(),
              child: Text("Simpan", style: tstyle(20, color: Colors.white)),
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
