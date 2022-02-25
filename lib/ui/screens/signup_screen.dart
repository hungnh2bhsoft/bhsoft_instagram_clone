import 'package:bhsoft_instagram_clone/providers/providers.dart';
import 'package:bhsoft_instagram_clone/ui/screens/screens.dart';
import 'package:bhsoft_instagram_clone/ui/widgets/widgets.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:bhsoft_instagram_clone/utils/global_variables.dart';
import 'package:bhsoft_instagram_clone/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => SignUpProvider(),
      child: Consumer<SignUpProvider>(
        builder: (context, signUpProvider, _) => Scaffold(
          resizeToAvoidBottomInset: true,
          body: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      size.width <= kMobileMaxWidth ? 32 : size.width / 3),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/ic_instagram.svg',
                      color: kPrimaryColor,
                      height: 64,
                    ),
                    const SizedBox(
                      height: 64,
                    ),
                    _buildAvatar(context),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      hintText: 'Your unique username',
                      textInputType: TextInputType.text,
                      onChanged: signUpProvider.setUsername,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      hintText: 'Email',
                      textInputType: TextInputType.emailAddress,
                      onChanged: signUpProvider.setEmail,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      hintText: 'Password',
                      textInputType: TextInputType.text,
                      onChanged: signUpProvider.setPassword,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      hintText: 'bio',
                      textInputType: TextInputType.text,
                      onChanged: signUpProvider.setBio,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    InkWell(
                      onTap: () async {
                        await signUpProvider.signUp();
                        if (signUpProvider.error != null) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                backgroundColor: kSecondaryColor,
                                content: Text(signUpProvider.error!),
                              ),
                            );
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        child: signUpProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: kPrimaryColor,
                              )
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
                    ),
                    const SizedBox(
                      height: 12,
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
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
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
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Consumer<SignUpProvider>(
      builder: (context, signUpProvider, _) => Stack(
        children: [
          signUpProvider.file != null
              ? CircleAvatar(
                  radius: 64,
                  backgroundImage: MemoryImage(signUpProvider.file!),
                  backgroundColor: Colors.red,
                )
              : const CircleAvatar(
                  radius: 64,
                  backgroundImage: AssetImage("assets/user_dummy.jpeg"),
                  backgroundColor: Colors.red,
                ),
          Positioned(
            bottom: -10,
            left: 80,
            child: IconButton(
              onPressed: () async {
                signUpProvider.setFile(await pickImage(ImageSource.gallery));
              },
              icon: const Icon(Icons.add_a_photo),
            ),
          )
        ],
      ),
    );
  }
}
