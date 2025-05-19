import 'package:flutter/material.dart';
import 'package:task_manager_project/controller/auth_controller.dart';
import 'package:task_manager_project/view/login_view.dart';
import 'package:task_manager_project/view/privacy_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _acceptPrivacyPolicy = false;

  void _register() async {
    if (!_acceptPrivacyPolicy) {
      setState(() {
        _errorMessage = "You must accept the Privacy Policy.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String? error = await _authController.registerUser(
      _nameController.text.trim(),
      _surnameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
      _errorMessage = error;
    });

    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

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
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_add_alt_1,
                        size: 55, color: Color.fromARGB(120, 255, 255, 255)),
                    const SizedBox(height: 10),
                    const Text(
                      "Create Account",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Sign up to get started",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                        _nameController, Icons.person, "First Name"),
                    const SizedBox(height: 15),
                    _buildTextField(
                        _surnameController, Icons.person_outline, "Last Name"),
                    const SizedBox(height: 15),
                    _buildTextField(_emailController, Icons.email, "Email"),
                    const SizedBox(height: 15),
                    _buildTextField(_passwordController, Icons.lock, "Password",
                        isPassword: true),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptPrivacyPolicy,
                          onChanged: (bool? value) {
                            setState(() {
                              _acceptPrivacyPolicy = value ?? false;
                            });
                          },
                          activeColor: Colors.blueAccent,
                        ),
                        const Text(
                          "I agree to the ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PrivacyPolicyPage()),
                            );
                          },
                          child: const Text(
                            "Privacy Policy",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : _buildRegisterButton(),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, IconData icon, String labelText,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _register,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(177, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
      ),
      child: const Text(
        "Register",
        selectionColor: Colors.transparent,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(129, 0, 0, 0)),
      ),
    );
  }
}
