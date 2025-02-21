// ignore_for_file: use_build_context_synchronously, file_names

import 'package:bigtable_connect/services/auth_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'Signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late String fcmToken = "";
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    _getFcmToken();
  }

  Future<void> _getFcmToken() async {
    // await _messagingService.init(context);
    fcmToken = (await _fcm.getToken())!;
  }

  // New field to track if the email exists
  bool isEmailValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1B4D3E),
                Color(0xFF124335),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    "assets/Logo/logo-no-background.png",
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF8F9779).withOpacity(0.4),
                          const Color(0xFF8F9779).withOpacity(0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8F9779).withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _emailFormKey,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              inputDecorationTheme: const InputDecorationTheme(
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter email';
                                }
                                if (!isEmailValid) {
                                  return 'User does not exist';
                                }
                                return null;
                              },
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              onChanged: (value) {
                                // Reset email validity on each input change
                                setState(() {
                                  isEmailValid = true;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Form(
                          key: _passwordFormKey,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              inputDecorationTheme: const InputDecorationTheme(
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            child: TextFormField(
                              controller: passwordController,
                              onTap: () async {
                                // Validate email field when password field is tapped
                                // bool emailExists =
                                // await checkEmail(emailController.text);
                                // if (!emailExists) {
                                //   // If email does not exist, show error
                                //   setState(() {
                                //     isEmailValid = false;
                                //   });
                                //   // Revalidate email form to show error message
                                //   _emailFormKey.currentState!.validate();
                                // }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                              obscureText: isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0xff1B4D3E),
                                  ),
                                  onPressed: () {
                                    _togglePasswordVisibility(context);
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1B4D3E).withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_emailFormKey.currentState!.validate()) {
                                if (_passwordFormKey.currentState!.validate()) {
                                  AuthService().signIn(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      context: context,
                                      FcmToken: fcmToken);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B4D3E),
                              shadowColor: const Color(0xFF1B4D3E),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'LOG IN',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Divider(
                            height: MediaQuery.of(context).size.height * 0.05),
                        ElevatedButton(
                          onPressed: () async {
                            await AuthService()
                                .signInWithGoogle(fcmToken, context);
                            // Navigator.pop(context);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const HomeScreen(),
                            //   ),
                            // );
                          },
                          child: ListTile(
                            leading: Image.asset(
                              "assets/Logo/google.webp",
                              height:
                                  MediaQuery.of(context).size.height * 0.035,
                            ),
                            title: const Text("Sign In with Google"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Haven't we met yet? ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'REGISTER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility(BuildContext context) {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

// Future<bool> checkEmail(String email) async {
//   var url = "http://$IP/checkEmail/$email";
//   try {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       var status = jsonDecode(response.body);
//       return status;
//     } else {
//       if (kDebugMode) {
//         print('Failed to load users: ${response.statusCode}');
//       }
//     }
//   } catch (e) {
//     if (kDebugMode) {
//       print('Error: $e');
//     }
//   }
//   return false;
// }

// void _performLogin(
//     String email, String password, BuildContext context) async {
//   var url = "http://$IP/login?email=$email&password=$password";
//   try {
//     final response = await http.get(Uri.parse(url));
//     if (response.body == "true") {
//       var getUserURL = "http://$IP/getUser/$email";
//       final getUserResponse = await http.get(Uri.parse(getUserURL));
//       if (getUserResponse.statusCode == 200) {
//         var getUserResponseBody = await jsonDecode(getUserResponse.body);
//         if (getUserResponseBody["category"] == "Founder") {
//           await saveKey(getUserResponseBody["userId"]);
//           await saveData("Category",getUserResponseBody["category"]);
//           await saveData("Email",getUserResponseBody["email"]);
//           Navigator.pop(context);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const FounderBottomNavigationBar(),
//             ),
//           );
//         }
//       } else {
//         showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: const Text("Problem in Login"),
//                 content: const Text(
//                     "There is some issue with the login please try again."),
//                 actions: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text("Ok"),
//                   )
//                 ],
//               );
//             });
//       }
//     } else {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text("Invalid email or password"),
//             content: const Text(
//                 "Entered email id or password is incorrect. Please try again."),
//             actions: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text("Ok"),
//               )
//             ],
//           );
//         },
//       );
//     }
//   } catch (e) {
//     if (kDebugMode) {
//       print('Error: $e');
//     }
//   }
// }
}
