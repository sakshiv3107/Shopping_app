import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  bool loading = false;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    bool isTablet = width > 600;
    bool isDesktop = width > 1000;

    double horizontalPadding = isTablet ? width * 0.2 : 20;
    double titleSize = isTablet ? 40 : 32;
    double subtitleSize = isTablet ? 18 : 16;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 247, 249, 1),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 500 : double.infinity
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),

                    child:SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.05),
                          Center(
                          child: Text(
                            'Welcome\nBack',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height:height * 0.01),
                        Center(
                          child: Text(
                            'Sign in to your account',
                            style: TextStyle(
                              fontSize: subtitleSize,
                              color: const Color.fromRGBO(119, 119, 119, 1),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.06),

                        const SizedBox(height: 8),

                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),

                        // PASSWORD FIELD
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outlined),

                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                          ),
                          ),
                        ),
                         SizedBox(height: height * 0.04),
                          SizedBox(
                          width: double.infinity,

                          child: loading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color:Color.fromRGBO(59, 134, 254, 1),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    if (emailController.text.isEmpty ||
                                        passwordController.text.isEmpty) {

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Please fill all fields'),
                                        ),
                                      );
                                      return;
                                    }

                                    setState(() => loading = true);

                                    try {
                                      await authService.signIn(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(e.toString()),
                                        ),
                                      );
                                    }

                                    setState(() => loading = false);
                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(59, 160, 254, 1),

                                    padding: EdgeInsets.symmetric(
                                      vertical: isTablet ? 18 : 14,
                                    ),

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),

                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: isTablet ? 18 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                        ),

                            SizedBox(height: height * 0.03),
                            Row(
                            children: [
                                const Expanded(
                                  child: Divider(
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'or',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(119, 119, 119, 1),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.03),

                            // GOOGLE BUTTON
                            SizedBox(
                              width: double.infinity,

                              child: OutlinedButton(
                                onPressed: () async {
                                  setState(() => loading = true);

                                  try {
                                    await authService.signInWithGoogle();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }

                                  setState(() => loading = false);
                                },

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/google_logo.png',
                                      height: isTablet ? 26 : 22,
                                    ),

                                    const SizedBox(width: 12),

                                    const Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.03),
                            
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(119, 119, 119, 1),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const SignupPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(59, 134, 254, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }

      @override
      void dispose() {
        emailController.dispose();
        passwordController.dispose();
        super.dispose();
      }
    }