import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lobrand_flutter/resources/auth_methods.dart';
import 'package:lobrand_flutter/screens/signup_screen.dart';
// import 'package:lobrand_flutter/screens/home_screen.dart';
import 'package:lobrand_flutter/utils/color.dart';
import 'package:lobrand_flutter/utils/utils.dart';
import 'package:lobrand_flutter/widgets/text_field_input.dart';

import '../responsive/mobile_layout_screen.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_layout_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    setState(() {
      _isLoading = false;
    });
    if (res == "success") {
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
            ) 
          )
      );
    } else {
      showSnackBar(res, context);
    }
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Container(), flex: 2),
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                  const SizedBox(height: 64),
                  TextFieldInput(
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                  ),
                  const SizedBox(height: 24),
                  TextFieldInput(
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    isPass: true,
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: loginUser,
                    child: Container(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor),
                            )
                          : const Text('Log in'),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        color: blueColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(child: Container(), flex: 2),
                  // Sign_up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: const Text("Don't have an account?"),
                          padding: const EdgeInsets.symmetric(vertical: 8)),
                      GestureDetector(
                        onTap: navigateToSignup,
                        child: Container(
                            child: const Text(" Sign up.",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            padding: const EdgeInsets.symmetric(vertical: 8)),
                      ),
                    ],
                  )
                ],
              ))),
    );
  }
}
