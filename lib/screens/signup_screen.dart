// import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lobrand_flutter/resources/auth_methods.dart';
import 'package:lobrand_flutter/responsive/mobile_layout_screen.dart';
import 'package:lobrand_flutter/responsive/responsive_layout_screen.dart';
import 'package:lobrand_flutter/responsive/web_layout_screen.dart';
import 'package:lobrand_flutter/screens/login_screen.dart';
import 'package:lobrand_flutter/utils/color.dart';
import 'package:lobrand_flutter/utils/utils.dart';
import 'package:lobrand_flutter/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
            ) 
          )
      );
    }
  }

   void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
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
                  // CircleAvatar
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64, backgroundImage: MemoryImage(_image!))
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1223671392?k=20&m=1223671392&s=170667a&w=0&h=kEAA35Eaz8k8A3qAGkuY8OZxpfvn9653gDjQwDHZGPE='),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // username
                  TextFieldInput(
                    hintText: 'Enter your username',
                    textInputType: TextInputType.text,
                    textEditingController: _usernameController,
                  ),
                  const SizedBox(height: 24),
                  // email
                  TextFieldInput(
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                  ),
                  const SizedBox(height: 24),
                  // password
                  TextFieldInput(
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    isPass: true,
                  ),
                  const SizedBox(height: 24),
                  // bio
                  TextFieldInput(
                    hintText: 'Enter your bio',
                    textInputType: TextInputType.text,
                    textEditingController: _bioController,
                  ),
                  // button signup
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: signUpUser,
                    child: Container(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor))
                          : const Text('Sign up'),
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
                          child: const Text("Already have an account?"),
                          padding: const EdgeInsets.symmetric(vertical: 8)),
                      GestureDetector(
                        onTap: navigateToLogin,
                        child: Container(
                            child: const Text(" Login.",
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
