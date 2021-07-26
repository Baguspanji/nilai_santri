import 'package:firebase_database/firebase_database.dart';

class GetSantri {
  String _key;
  String _id_santri;
  String _kelas_santri;
  String _nama_santri;
  String _alamat_santri;

  GetSantri(
    this._key,
    this._id_santri,
    this._kelas_santri,
    this._nama_santri,
    this._alamat_santri,
  );

  GetSantri.map(dynamic obj) {
    this._id_santri = obj['id_santri'];
    this._kelas_santri = obj['kelas_santri'];
    this._nama_santri = obj['nama_santri'];
    this._alamat_santri = obj['alamat_santri'];
  }

  String get key => _key;
  String get id_santri => _id_santri;
  String get kelas_santri => _kelas_santri;
  String get nama_santri => _nama_santri;
  String get alamat_santri => _alamat_santri;

  GetSantri.fromSnapshot(DataSnapshot snapshot) {
    _key = snapshot.key;
    _id_santri = snapshot.value['id_santri'];
    _kelas_santri = snapshot.value['kelas_santri'];
    _nama_santri = snapshot.value['nama_santri'];
    _alamat_santri = snapshot.value['alamat_santri'];
  }
}

class GetNilai {
  String _key;
  String _tgl;
  String _kelas;
  String _ket;
  String _catatan;

  GetNilai(
    this._key,
    this._tgl,
    this._kelas,
    this._ket,
    this._catatan,
  );

  GetNilai.map(dynamic obj) {
    this._tgl = obj['tgl'];
    this._kelas = obj['kelas'];
    this._ket = obj['ket'];
    this._catatan = obj['_catatan'];
  }

  String get key => _key;
  String get tgl => _tgl;
  String get kelas => _kelas;
  String get ket => _ket;
  String get catatan => _catatan;

  GetNilai.fromSnapshot(DataSnapshot snapshot) {
    _key = snapshot.key;
    _tgl = snapshot.value['tgl'];
    _kelas = snapshot.value['kelas'];
    _ket = snapshot.value['ket'];
    _catatan = snapshot.value['catatan'];
  }
}
