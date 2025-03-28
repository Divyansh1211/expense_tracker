import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/features/auth/views/login.dart';
import 'package:neosurge_fe/features/auth/views/widgets/text_input_widget.dart';
import 'package:neosurge_fe/features/auth/controller/profile_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Let's get started!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(height: h * 0.01),
              Text(
                'Sign up to continue',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: h * 0.04),
              InputFieldWidget(
                controller: _nameController,
                title: "Name",
              ),
              SizedBox(height: h * 0.02),
              InputFieldWidget(
                  controller: _emailController,
                  title: "Email",
                  type: TextInputType.emailAddress),
              SizedBox(height: h * 0.02),
              InputFieldWidget(
                controller: _passwordController,
                obscureText: true,
                title: "Password",
                type: TextInputType.visiblePassword,
              ),
              SizedBox(height: h * 0.02),
              InputFieldWidget(
                controller: _confirmPasswordController,
                obscureText: true,
                title: "Confirm",
                type: TextInputType.visiblePassword,
              ),
              SizedBox(height: h * 0.02),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                    return;
                  }
                  final res =
                      await ref.read(profileController.notifier).signUpUser(
                            context: context,
                            email: _emailController.text,
                            name: _nameController.text,
                            password: _passwordController.text,
                          );
                  if (!res["success"]) {
                    context.mounted
                        ? ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(res["message"])),
                          )
                        : null;
                  }
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text("Login"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
