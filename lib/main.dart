import 'package:flutter/material.dart'; // Import library dasar dari Flutter
import 'package:flutter_application_1/sqlite_db.dart'; // Import file sqlite_db.dart yang berisi operasi database
import 'dart:io'; // Import library Dart untuk operasi I/O
import 'package:path_provider/path_provider.dart'; // Import library path_provideruntuk mengakses path penyimpanan file
import 'package:file_picker/file_picker.dart'; // Import library file_picker untuk memilih file dari sistem file
import 'package:flutter_application_1/model/buku.dart';
import 'package:flutter_application_1/model/foto.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Multitable',
      home: const MyHomePage(title: 'Flutter Multitable'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController judulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController fotoController = TextEditingController();

  List<Map<String, dynamic>> catatan = [];

  void refreshBuku() async {
    final data = await SQLHelper.getBuku(); // Perubahan disini, mengubah getCatatan menjadi getBuku
    setState(() {
      catatan = data;
    });
  }

  @override
  void initState() {
    refreshBuku();
    super.initState();
  }

  Future<void> tambahCatatan() async {
    await SQLHelper.tambahBuku(Buku (judul: judulController.text, deskripsi: deskripsiController.text, photo: '')); // Perubahan disini, mengubah tambahcatatan menjadi tambahBuku
    refreshBuku();
  }

  Future<void> hapusCatatan(int id) async {
    await SQLHelper.deleteBuku(id); // Perubahan disini, mengubah hapuscatatan menjadi deleteBuku
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Berhasil Dihapus"),
    ));
    refreshBuku();
  }

  Future<void> ubahCatatan(int id) async {
    await SQLHelper.updateBuku(Buku(id: id, judul: judulController.text, deskripsi: deskripsiController.text, photo: '')); // Perubahan disini, mengubah ubahCatatan menjadi updateBuku
    refreshBuku();
  }

  void modalForm(id) async {
    if (id != null) {
      final dataCatatan = catatan.firstWhere((item) => item['id'] == id);

      judulController.text = dataCatatan['judul'];
      deskripsiController.text = dataCatatan['deskripsi'];
      fotoController.text = dataCatatan['foto'];
    }
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        height: 800,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: judulController,
                decoration: const InputDecoration(hintText: "Judul"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: deskripsiController,
                decoration: const InputDecoration(hintText: "Deskripsi"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await tambahCatatan();
                    print("Tambah");
                  } else {
                    print("Update");
                    await ubahCatatan(id);
                  }
                  judulController.text = '';
                  deskripsiController.text = '';
                  Navigator.pop(context);
                },
                child: Text(id == null ? 'Tambah' : 'Ubah'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: catatan.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text(catatan[index]['judul']),
            subtitle: Text(catatan[index]['deskripsi']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => modalForm(catatan[index]['id']),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      hapusCatatan(catatan[index]['id']);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalForm(null);
        },
        tooltip: 'Tambah Catatan',
        child: const Icon(Icons.add),
      ),
    );
  }
}