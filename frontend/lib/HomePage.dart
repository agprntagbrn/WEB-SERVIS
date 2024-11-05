import 'package:flutter/material.dart';
import 'package:frontend/create.dart';
import 'package:frontend/delete_data.dart';
import 'package:frontend/display_data.dart';
import 'package:frontend/update_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );

  void _navigateTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: _buttonStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE2E8E4),  // Sage green yang lebih lembut
              Color(0xFFFFF8E7),  // Cream yang lebih lembut
            ],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withOpacity(0.9),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to the App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                
                _buildButton(
                  icon: Icons.create,
                  label: 'CREATE',
                  onPressed: () => _navigateTo(CreateScreen()),
                ),
                _buildButton(
                  icon: Icons.read_more_rounded,
                  label: 'READ',
                  onPressed: () => _navigateTo(DisplayScreen()),
                ),
                _buildButton(
                  icon: Icons.update,
                  label: 'UPDATE',
                  onPressed: () => _navigateTo(UpdateScreen()),
                ),
                _buildButton(
                  icon: Icons.delete,
                  label: 'DELETE',
                  onPressed: () => _navigateTo(DeleteScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
