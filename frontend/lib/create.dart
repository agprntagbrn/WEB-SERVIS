import 'package:flutter/material.dart';
import 'package:frontend/services/api.dart';

class CreateScreen extends StatefulWidget {
  @override
  CreateScreenState createState() {
    return CreateScreenState();
  }
}

class CreateScreenState extends State<CreateScreen> {
  final namaController = TextEditingController();
  final nimController = TextEditingController();
  final jurusanController = TextEditingController();
  bool isLoading = false;
  String feedbackMessage = '';

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    namaController.dispose();
    nimController.dispose();
    jurusanController.dispose();
    super.dispose();
  }

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Person Data"),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blueAccent, Colors.greenAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Main Input Container
          Center(
            child: SingleChildScrollView(  // Added scrolling support
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white.withOpacity(0.9),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(  // Wrapped in Form widget
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text Fields
                      _buildTextField(namaController, "Nama"),
                      const SizedBox(height: 15),
                      _buildTextField(nimController, "NIM"),
                      const SizedBox(height: 15),
                      _buildTextField(jurusanController, "Jurusan"),
                      const SizedBox(height: 20),
                      // Submit Button with Loading Indicator
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Submit",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                      const SizedBox(height: 20),
                      // Feedback Message
                      if (feedbackMessage.isNotEmpty)
                        Text(
                          feedbackMessage,
                          style: TextStyle(
                            color: feedbackMessage.contains("Success") ? Colors.green : Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
        hintStyle: const TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        prefixIcon: Icon(
          hintText == "Nama" ? Icons.person :
          hintText == "NIM" ? Icons.numbers :
          Icons.school,
          color: Colors.blueAccent,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hintText tidak boleh kosong';
        }
        if (hintText == "NIM" && !RegExp(r'^\d+$').hasMatch(value)) {
          return 'NIM harus berupa angka';
        }
        return null;
      },
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
      feedbackMessage = '';
    });

    var data = {
      "nama": namaController.text,
      "nim": nimController.text,
      "jurusan": jurusanController.text,
    };

    try {
      await Api.addPerson(data);
      setState(() {
        feedbackMessage = "Success: Person data added!";
        namaController.clear();
        nimController.clear();
        jurusanController.clear();
      });
    } catch (e) {
      setState(() {
        feedbackMessage = "Error: Unable to add person data.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
