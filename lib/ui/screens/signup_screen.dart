import 'dart:typed_data';

import 'package:bhsoft_instagram_clone/resources/auth_methods.dart';
import 'package:bhsoft_instagram_clone/ui/screens/screens.dart';
import 'package:bhsoft_instagram_clone/ui/widgets/widgets.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:bhsoft_instagram_clone/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Uint8List? _image;

  bool isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  void _showLoginScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
  }

  void _signUp(BuildContext context) async {
    try {
      await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        username: _usernameController.text,
        file: _image,
      );
      // Navigator.of(context)
      //     .pushReplacement(MaterialPageRoute(builder: (context) {
      //   return HomeScreen();
      // }));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: kSecondaryColor,
            content: Text(e.message),
          ),
        );
    }
  }

  void _selectImage() async {
    final galleryImage = await pickImage();
    setState(() {
      if (galleryImage != null) {
        _image = galleryImage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: kprimaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              _buildArvatar(),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Your unique username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                obscureText: true,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'bio',
                textInputType: TextInputType.text,
                textEditingController: _bioController,
              ),
              const SizedBox(
                height: 24,
              ),
              _buildLoginButton(context),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                      'Already have an account?',
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: () => _showLoginScreen(context),
                    child: Container(
                      child: const Text(
                        ' Log in.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack _buildArvatar() {
    return Stack(
      children: [
        _image != null
            ? CircleAvatar(
                radius: 64,
                backgroundImage: MemoryImage(_image!),
                backgroundColor: Colors.red,
              )
            : const CircleAvatar(
                radius: 64,
                backgroundImage:
                    NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                backgroundColor: Colors.red,
              ),
        Positioned(
          bottom: -10,
          left: 80,
          child: IconButton(
            onPressed: _selectImage,
            icon: const Icon(Icons.add_a_photo),
          ),
        )
      ],
    );
  }

  InkWell _buildLoginButton(BuildContext context) {
    return InkWell(
      onTap: () => _signUp(context),
      child: Container(
        child: isLoading
            ? const CircularProgressIndicator()
            : const Text('Sign Up'),
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          color: kBlueColor,
        ),
      ),
    );
  }
}
