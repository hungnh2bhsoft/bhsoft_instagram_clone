import 'package:bhsoft_instagram_clone/providers/providers.dart';
import 'package:bhsoft_instagram_clone/ui/screens/screens.dart';
import 'package:bhsoft_instagram_clone/ui/widgets/widgets.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: Consumer<LoginProvider>(
        builder: (context, loginProvider, _) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/ic_instagram.svg',
                        color: kPrimaryColor,
                        height: 64,
                      ),
                      const SizedBox(
                        height: 64,
                      ),
                      TextFieldInput(
                        onChanged: loginProvider.setEmail,
                        hintText: 'Enter your email',
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFieldInput(
                        onChanged: loginProvider.setPassword,
                        hintText: 'Enter your password',
                        textInputType: TextInputType.text,
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await loginProvider.login();
                          if (loginProvider.error != null) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                  content: Text(loginProvider.error!)));
                          }
                        },
                        child: Container(
                          child: loginProvider.isLoading
                              ? const CircularProgressIndicator.adaptive()
                              : const Text(
                                  'Log in',
                                ),
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const ShapeDecoration(
                            color: kBlueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                          ),
                          GestureDetector(
                            onTap: () => _showSignUpScreen(context),
                            child: const Text(
                              ' Sign Up.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSignUpScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }
}
