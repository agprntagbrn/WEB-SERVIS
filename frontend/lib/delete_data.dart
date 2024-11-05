import 'package:flutter/material.dart';
import 'package:frontend/services/Api.dart';

class DeleteScreen extends StatefulWidget {
  @override
  DeleteScreenState createState() => DeleteScreenState();
}

class DeleteScreenState extends State<DeleteScreen> {
  List<dynamic> personData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPersonData();
  }

  // Fungsi untuk menampilkan snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Fungsi untuk mengambil data dari API
  void fetchPersonData() async {
    setState(() => isLoading = true);
    try {
      var data = await Api.getPerson();
      setState(() {
        personData = data['persons'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar('Gagal mengambil data: $e');
    }
  }

  // Fungsi untuk menghapus data berdasarkan ID
  Future<void> deletePerson(int id) async {
    try {
      await Api.deletePerson(id);
      _showSnackBar('Data berhasil dihapus');
      fetchPersonData();
    } catch (e) {
      _showSnackBar('Gagal menghapus data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Person Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchPersonData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: const CircularProgressIndicator())
          : personData.isEmpty
              ? const Center(child: const Text("No person data available."))
              : Container(
                  decoration: const BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.greenAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: personData.length,
                    itemBuilder: (context, index) {
                      final person = personData[index];
                      return Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text("Nama: ${person['nama']}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("NIM: ${person['nim']}"),
                              Text("Jurusan: ${person['jurusan']}"),
                            ],
                          ),
                          leading: const Icon(Icons.person),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Hapus Data"),
                                        content: const Text("Apakah Anda yakin ingin menghapus data ini?"),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: const Text("Batal"),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.grey,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              deletePerson(person['id']);
                                            },
                                            child: const Text("Hapus"),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                tooltip: 'Hapus Data',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
