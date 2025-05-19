import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

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
                    "About Task Manager",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Naša misija storji na dejstvu, da ponudnikom ponudimoo najboljšo uporabniško izkušnjo.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoCard(
                    title: "Naša misija",
                    content:
                        "Naša misija storji na dejstvu, da ponudnikom ponudimoo najboljšo uporabniško izkušnjo.",
                    icon: Icons.flag,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                      title: "Funkcije",
                      content:
                          "Ustavrjanje opravil in urejanje le-teh \n sledenje opravil v realnem času \n dodajanje datotek \n ",
                      icon: Icons.get_app),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    title: "Zaščita podatkov",
                    content:
                        "Vaši podatki so strogo varovani in zaščiteni z standardno enkripcijo ( predvsem gesla). S tem vam omogočamo popolno varnost in zaščito osebnih posatkov.",
                    icon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    title: "Zaposleni v podjetju",
                    content:
                        "Dostop imate do listo zaposlenih, njihovih statusov in njihove vloge",
                    icon: Icons.people,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                      title: "Hvala za uporabo!",
                      content: "Hvala za vašo uporabo apliakcije",
                      icon: Icons.thumb_up),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Telekom Slovenjie Task Manager App © 2025",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.0),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon,
            color: const Color.fromARGB(255, 255, 255, 255), size: 30),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        subtitle: Text(
          content,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
