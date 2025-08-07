import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart'; // Import to access AnimatedBackground & BackgroundShapes
import 'admin_home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';
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
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackground()),
          const Positioned.fill(child: BackgroundShapes()),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    27,
                    145,
                    141,
                  ).withAlpha((255 * 0.2).toInt()),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        27,
                        145,
                        141,
                      ).withAlpha((255 * 0.2).toInt()),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
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
                        child: const Text('Forgot Password?'),
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
                          } else {
                            // Sign Up logic can be added here
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
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

                    // Social Login Section
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
                          icon: const FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            try {
                              final GoogleSignIn googleSignIn = GoogleSignIn();
                              final GoogleSignInAccount? googleUser =
                                  await googleSignIn.signIn();

                              if (!context.mounted) return;

                              if (googleUser != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Signed in as ${googleUser.email}',
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Google Sign-In Failed: $e'),
                                ),
                              );
                            }
                          },
                        ),

                        const SizedBox(width: 16),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.twitter,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            final twitterLogin = TwitterLogin(
                              apiKey: 'YOUR_TWITTER_API_KEY',
                              apiSecretKey: 'YOUR_TWITTER_SECRET_KEY',
                              redirectURI: 'YOUR_CALLBACK_URL',
                            );

                            final authResult = await twitterLogin.login();

                            if (!context.mounted) return;

                            switch (authResult.status) {
                              case TwitterLoginStatus.loggedIn:
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Twitter: ${authResult.user?.name}',
                                    ),
                                  ),
                                );
                                break;
                              case TwitterLoginStatus.cancelledByUser:
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Twitter Sign-In Cancelled'),
                                  ),
                                );
                                break;
                              case TwitterLoginStatus.error:
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Twitter Error: ${authResult.errorMessage}',
                                    ),
                                  ),
                                );
                                break;
                              default:
                                break;
                            }
                          },
                        ),

                        const SizedBox(width: 16),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.microsoft,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            const oauthUrl =
                                'https://login.microsoftonline.com/common/oauth2/v2.0/authorize'
                                '?client_id=YOUR_MICROSOFT_CLIENT_ID'
                                '&response_type=token'
                                '&redirect_uri=YOUR_REDIRECT_URI'
                                '&scope=User.Read';

                            final uri = Uri.parse(oauthUrl);

                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Could not launch Microsoft Sign-In',
                                  ),
                                ),
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
        ],
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
        borderSide: const BorderSide(color: Colors.blueAccent),
      ),
    );
  }
}
