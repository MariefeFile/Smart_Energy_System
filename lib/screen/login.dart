import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'admin_home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ✅ Dark gradient background (same as admin_home.dart)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1a2332), Color(0xFF0f1419)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox( // ✅ Added
              constraints: const BoxConstraints(maxWidth: 500), // set max width
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((255 * 0.05).toInt()), // subtle overlay
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   Text(
  isLogin ? 'Welcome Back!' : 'Create an Account',
  style: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
),
const SizedBox(height: 6),
Text(
  isLogin ? 'Log in to your account' : 'Sign up to get started',
  style: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
  ),
),

                    const SizedBox(height: 20),
                    if (!isLogin)
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Name', Icons.person),
                      ),
                    if (!isLogin) const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Email', Icons.email),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Password', Icons.lock),
                    ),
                    if (isLogin)
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password?',
                            style: TextStyle(color: Colors.white70)),
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isLogin) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(isLogin ? 'Login' : 'Sign Up'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLogin
                              ? "Don't have an account?"
                              : "Already have an account?",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            isLogin ? 'Sign Up' : 'Login',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.google,
                              color: Colors.white),
                          onPressed: () async {
                            final GoogleSignIn googleSignIn = GoogleSignIn();
                            final GoogleSignInAccount? googleUser =
                                await googleSignIn.signIn();
                            if (!context.mounted) return;
                            if (googleUser != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Signed in as ${googleUser.email}')),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        // ✅ Facebook Login Button
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.facebook,
                              color: Colors.white),
                          onPressed: () async {
                            const fbUrl =
                                'https://www.facebook.com/v15.0/dialog/oauth'
                                '?client_id=YOUR_FACEBOOK_APP_ID'
                                '&redirect_uri=YOUR_REDIRECT_URI'
                                '&response_type=token'
                                '&scope=email,public_profile';
                            final uri = Uri.parse(fbUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Could not launch Facebook Sign-In')),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.microsoft,
                              color: Colors.white),
                          onPressed: () async {
                            const oauthUrl =
                                'https://login.microsoftonline.com/common/oauth2/v2.0/authorize'
                                '?client_id=YOUR_MICROSOFT_CLIENT_ID'
                                '&response_type=token'
                                '&redirect_uri=YOUR_REDIRECT_URI'
                                '&scope=User.Read';
                            final uri = Uri.parse(oauthUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Could not launch Microsoft Sign-In')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.tealAccent),
      ),
    );
  }
}
