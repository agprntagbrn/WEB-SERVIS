import 'package:flutter/material.dart';
import 'package:frontend/services/Api.dart';
import 'package:frontend/edit_data.dart'; // Import the edit data screen

class UpdateScreen extends StatefulWidget {
  @override
  UpdateScreenState createState() => UpdateScreenState();
}

class UpdateScreenState extends State<UpdateScreen> {
  List<dynamic> personData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPersonData();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    await fetchPersonData();
  }

  Future<void> fetchPersonData() async {
    try {
      var data = await Api.getPerson();
      setState(() {
        personData = data['persons'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: ${e.toString()}')),
      );
    }
  }

  Future<void> _deletePerson(int id) async {
    try {
      await Api.deletePerson(id);
      await fetchPersonData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: const Text('Person deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete person: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Person Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: isLoading
            ? const Center(child: const CircularProgressIndicator())
            : personData.isEmpty
                ? const Center(
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text("No person data available."),
                      ],
                    ),
                  )
                : Container(
                    decoration: const BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blueAccent, Colors.greenAccent],
                      ),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: personData.length,
                      itemBuilder: (context, index) {
                        final person = personData[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(
                                "Nama: ${person['nama']}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("NIM: ${person['nim']}"),
                                  Text("Jurusan: ${person['jurusan']}"),
                                ],
                              ),
                              leading: CircleAvatar(
                                child: const Icon(Icons.person),
                                backgroundColor: Colors.blue.shade100,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => EditDataScreen(
                                            initialName: person['nama'],
                                            initialNIM: person['nim'],
                                            initialJurusan: person['jurusan'],
                                            id: person['id'],
                                            onUpdate: _refreshData,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete Person'),
                                          content: const Text('Are you sure you want to delete this person?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deletePerson(person['id']);
                                              },
                                              child: const Text('Delete'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}