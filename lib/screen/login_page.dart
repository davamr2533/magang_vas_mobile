import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/data/cubit/login/login_cubit.dart';
import 'package:vas_reporting/data/model/body/login_body.dart';
import 'package:vas_reporting/screen/home/home_page.dart';
import 'package:vas_reporting/base/base_colors.dart' as baseColors;
import 'package:vas_reporting/tools/popup.dart';
import 'package:vas_reporting/tools/routing.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false; //tambahan untuk view password

  late LoginCubit _loginCubit;
  late PopUpWidget popUpWidget;

  @override
  void initState() {
    super.initState();
    _loginCubit = context.read<LoginCubit>();
    popUpWidget = PopUpWidget(context);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
      if (state is LoginLoading) {
        setState(() {
          _isLoading = true;
        });
      } 
      if (state is LoginFailure) {
        setState(() {
          _isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          popUpWidget.showAlert(
            'Login Failed',
            state.message ?? "",
            true,
            'OK',
            LoginPage(),
          );
        });
      } 
      if (state is LoginSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          popUpWidget.showAlert(
            'Login Success',
            state.response.message ?? "",
            false,
            '',
            HomePage(),
          );
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pushAndRemoveUntil(
              routingPage(HomePage()),
              (Route<dynamic> route) => false,
            );
          });
        });
      }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 121, 97),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Expanded(
                  child: Center(
                    child: Image.asset(
                      "assets/login.png", 
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome to VAS Reporting",
                  style: GoogleFonts.urbanist(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Login to continue",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: "Username",
                    hintStyle: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: baseColors.secondaryColor,
                    prefixIcon: const Icon(
                      IconlyLight.message,
                      color: baseColors.primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible, //toggle view password
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: baseColors.secondaryColor,
                    prefixIcon: const Icon(
                      IconlyLight.lock,
                      color: baseColors.primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? IconlyLight.show : IconlyLight.hide,
                        color: baseColors.primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (_usernameController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        popUpWidget.showAlert(
                          'Error',
                          'Please enter both username and password.',
                          true,
                          'OK',
                          LoginPage(),
                        );
                        return;
                      }
                      _loginCubit.login(
                        loginBody: LoginBody(
                          username: _usernameController.text,
                          passwordKey: _passwordController.text,
                        ),
                      );
                    },
                    child: _isLoading
                    ? const CircularProgressIndicator(
                      color: Color.fromARGB(255, 235, 121, 97),
                    )
                    : Text(
                      "Log In",
                      style: GoogleFonts.urbanist(
                        color: Color.fromARGB(255, 235, 121, 97),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
