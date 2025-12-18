import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1B4B), // Dark deep purple
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "History Chat",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(color: Colors.white24),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Placeholder count
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(LucideIcons.messageSquare, color: Colors.white70),
                    title: Text(
                      "Chat Session ${index + 1}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Yesterday",
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                    onTap: () {
                      // Navigate to chat history
                    },
                  );
                },
              ),
            ),
            const Divider(color: Colors.white24),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildDrawerButton(
                    context, 
                    title: "Profiles", 
                    icon: LucideIcons.user, 
                    onTap: () => Navigator.pushNamed(context, '/profile')
                  ),
                  const SizedBox(height: 12),
                  _buildDrawerButton(
                    context, 
                    title: "Settings", 
                    icon: LucideIcons.settings, 
                    onTap: () {
                      // Settings action
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerButton(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(LucideIcons.chevronRight, color: Colors.white30, size: 18),
          ],
        ),
      ),
    );
  }
}
