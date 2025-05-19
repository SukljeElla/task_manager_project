import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(42, 35, 35, 59),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Privacy Policy",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Effective Date: March 19, 2025\n\n"
                        "Welcome to Telekom Task Manager. Your privacy is important to us, and we are committed to protecting your personal data. "
                        "This Privacy Policy explains how we collect, use, and safeguard your information when using our application.",
                        style: TextStyle(
                            color: Color.fromARGB(225, 255, 255, 255),
                            fontSize: 14),
                      ),
                      SizedBox(height: 20),
                      _PrivacySectionTitle("1. Information We Collect"),
                      _PrivacyParagraph(
                          "We collect the following types of information to provide and improve our services:\n\n"
                          "• **Personal Information**: Name, email, and user ID required for account creation.\n"
                          "• **Task & Usage Data**: Assigned tasks, comments, progress tracking.\n"
                          "• **Device Information**: Operating system, device type, and app version.\n"
                          "• **Network Information**: IP address and analytics for performance improvement."),
                      _PrivacySectionTitle("2. How We Use Your Information"),
                      _PrivacyParagraph(
                          "Your data is used for the following purposes:\n\n"
                          "✔ **Service Functionality**: Allowing authentication, task assignment, and user interaction.\n"
                          "✔ **Improvement**: Analyzing app usage to enhance performance.\n"
                          "✔ **Security**: Preventing unauthorized access and fraud.\n"
                          "✔ **Communication**: Sending important updates and support notifications."),
                      _PrivacySectionTitle("3. Data Sharing & Disclosure"),
                      _PrivacyParagraph(
                          "We do **not** sell or rent your personal data. However, your data may be shared:\n\n"
                          "• **With your consent**: When you voluntarily share information.\n"
                          "• **With administrators**: To manage team and project assignments.\n"
                          "• **For legal reasons**: If required by law or court order."),
                      _PrivacySectionTitle("4. Your Privacy Rights"),
                      _PrivacyParagraph(
                          "You have the following rights regarding your data:\n\n"
                          "🔹 **Access & Correction**: You can view and update your profile anytime.\n"
                          "🔹 **Data Deletion**: You may request to delete your account.\n"
                          "🔹 **Opt-Out**: You can disable notifications and limit data collection."),
                      _PrivacySectionTitle("5. Data Security"),
                      _PrivacyParagraph(
                          "We implement strict security measures to protect your data:\n\n"
                          "**Encryption**: All communication is securely encrypted.\n"
                          "**Access Controls**: Only authorized users can access necessary information.\n"
                          "**Regular Audits**: We conduct security reviews to prevent vulnerabilities."),
                      _PrivacySectionTitle("6. Retention of Data"),
                      _PrivacyParagraph(
                          "We retain your data as long as required to provide services. If you delete your account, we remove all personal data unless legally required to retain it."),
                      _PrivacySectionTitle("7. Changes to This Policy"),
                      _PrivacyParagraph(
                          "This policy may be updated from time to time. We will notify users of any changes via email or app notifications."),
                      _PrivacySectionTitle("8. Contact Information"),
                      _PrivacyParagraph(
                          "For any questions or concerns, contact us at:\n\n"
                          "📧 Email:support@telekomtaskmanager.com\n"
                          "📍 Address:Telekom Task Manager, 123 Business Ave, Tech City, Europe"),
                      SizedBox(height: 20),
                      Text(
                        "By using Telekom Task Manager, you agree to this Privacy Policy.",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30),
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
}

class _PrivacySectionTitle extends StatelessWidget {
  final String title;
  const _PrivacySectionTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(220, 255, 255, 255),
        ),
      ),
    );
  }
}

class _PrivacyParagraph extends StatelessWidget {
  final String content;
  const _PrivacyParagraph(this.content, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
    );
  }
}
