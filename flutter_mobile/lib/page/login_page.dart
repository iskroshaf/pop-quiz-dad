import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();
  // final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _checkStoredCredentials(); // Check for stored credentials
  }

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkStoredCredentials() async {
    // final prefs = await SharedPreferences.getInstance();

    // Retrieve token and auto-login if valid
    // final storedToken = prefs.getString('token');
    // final storedUser = prefs.getString('user');

    // if (storedToken != null) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => BasePage()),
    //   );
    // }
  }

  void _login() async {
    final usernameOrEmail = _usernameOrEmailController.text.trim();
    final password = _passwordController.text;

    // User? user = await _auth.signInWithEmailAndPassword(email, password);
    //
    // if (user != null) {
    //   print("User is successfully login");
    //   Navigator.pushNamed(context, "/home");
    // } else {
    //   print("Error occured");
    // }
    //
    // // Perform auth logic here
    // print("Email: $email, Password: $password");

    bool isLoading = false;

    if (!_formKey.currentState!.validate()) {
      return; // Exit if the form is invalid
    }

    setState(() {
      isLoading = true;
      // context.loaderOverlay.show();
    });

    // try {
    //   // Call the API and get the response
    //   final loginResponse = await apiService.login(usernameOrEmail, password);
    //
    //   // Save the token and user data to SharedPreferences
    //   await saveUserData(loginResponse.token, loginResponse.user);
    //   // print(loginResponse.user);
    //
    //   // User user = User.fromJson(loginResponse.user);
    //
    //   // Show success message and navigate to login
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Login successful!')),
    //   );
    //   _basepage(); // Navigate to the Home page
    // } catch (e) {
    //   // Extract meaningful error messages if available
    //   final errorMsg = e.toString().replaceFirst('Exception: ', '');
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('$errorMsg')),
    //   );
    //   print(errorMsg);
    // } finally {
    //   setState(() {
    //     isLoading = false;
    //     context.loaderOverlay.hide();
    //   });
    // }
  }

  Future<void> saveUserData(String token, Map<String, dynamic> user) async {
    // final prefs = await SharedPreferences.getInstance();
    //
    // // Save token
    // await prefs.setString('token', token);
    //
    // // Save user data
    // await prefs.setString('user', jsonEncode(user));
    //
    // print(prefs.getString('user'));
    //
    // // Optionally save individual user fields for easier access
    // await prefs.setInt('userId', user['id']);
    // await prefs.setString('username', user['username']);
    // await prefs.setString('email', user['email']);
    // await prefs.setString('name', user['name']);

    // // Save other relevant user fields
    // if (user['phone_num'] != null) {
    //   await prefs.setString('phoneNum', user['phone_num']);
    // }
    // if (user['bio'] != null) {
    //   await prefs.setString('bio', user['bio']);
    // }
    // await prefs.setInt('totalFollower', user['total_follower']);
    // await prefs.setString('averageRating', user['average_rating']);
    // await prefs.setInt('verificationStatus', user['verification_status']);
    // await prefs.setInt('status', user['status']);
  }

  void _signup() {
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignupPage()), (route) => false);
  }

  void _resetPasswordPage() {
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ResetPasswordPage()), (route) => false);
  }

  void _basepage() {
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BasePage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.1),
                    // Image.asset(
                    //   'assets/SS_Header_Transparent_16-9.png',
                    //   height: 150,
                    // ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Pop Quiz",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.10),
                    // Form fields section
                    TextFormField(
                      controller: _usernameOrEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Username / Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username or email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    // Buttons section
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // TextButton(
                    //   onPressed: _resetPasswordPage,
                    //   child: Text("Forgot Password?"),
                    // ),

                    // Add bottom padding when keyboard is open
                    SizedBox(
                        height: isKeyboardOpen
                            ? screenHeight * 0.1
                            : screenHeight * 0.05),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
