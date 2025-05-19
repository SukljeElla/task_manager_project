import 'package:flutter/material.dart';
import 'package:task_manager_project/controller/ticket_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager_project/view/login_view.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TicketController _ticketController = TicketController();
  final TextEditingController _ticketTextController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      bool confirmDelete = await _showConfirmDialog(context);
      if (confirmDelete) {
        await user.delete();
        await auth.signOut();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false,
        );
      }
    }
  }

  Future<bool> _showConfirmDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to delete your account permanently? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _submitTicket() async {
    String issueText = _ticketTextController.text.trim();

    if (issueText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid issue description')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _ticketController.createTicket(issueText);
      _ticketTextController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting ticket: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 86, 174, 201), Color(0xFF23233B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "How can we help you?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Find answers to your questions or contact us for assistance.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  _buildSupportCard(
                    icon: Icons.help_outline,
                    title: "Help Center",
                    subtitle: "Find answers to common questions",
                    onTap: () =>
                        _launchURL("https://support.telekomslovenija.com"),
                  ),
                  _buildSupportCard(
                    icon: Icons.email_outlined,
                    title: "Contact Us",
                    subtitle: "support@telekomslovenija.com",
                    onTap: () =>
                        _launchURL("mailto:support@telekomslovenija.com"),
                  ),
                  _buildSupportCard(
                    icon: Icons.phone_in_talk_outlined,
                    title: "Call Support",
                    subtitle: "+386 1 234 5678",
                    onTap: () => _launchURL("tel:+38612345678"),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _deleteAccount(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(20, 240, 240, 240),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 19, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Delete My Account",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Submit a Ticket",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _ticketTextController,
                    decoration: InputDecoration(
                      labelText: "Describe your issue",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      labelStyle: const TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitTicket,
                    icon: const Icon(Icons.send,
                        color: Color.fromARGB(84, 0, 0, 0)),
                    label: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Submit Ticket",
                            selectionColor: Colors.transparent,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(129, 0, 0, 0)),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(117, 221, 224, 224),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                    width: 12,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.0),
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon,
              color: const Color.fromARGB(255, 255, 255, 255), size: 30),
          title: Text(title,
              style: const TextStyle(
                  color: Color.fromARGB(255, 220, 217, 217), fontSize: 18)),
          subtitle:
              Text(subtitle, style: const TextStyle(color: Colors.white70)),
          trailing: const Icon(Icons.arrow_forward_ios,
              color: Color.fromARGB(161, 255, 255, 255), size: 16),
        ),
      ),
    );
  }
}
