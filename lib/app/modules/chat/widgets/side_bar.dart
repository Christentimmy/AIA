
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildDrawer extends StatelessWidget {
  const BuildDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 7, 6, 6),
      child: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 20,
        ),
        children: [
          const SizedBox(height: 20),
          // Title
          Row(
            children: [
              Text(
                "AIA",
                style: GoogleFonts.orbitron(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),

          ListTile(
            leading: const Icon(
              Icons.chat_bubble,
              color: Colors.white,
            ),
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'AI Session 1',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
            ),
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'AI Session 2',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
