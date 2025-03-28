import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/features/auth/views/widgets/text_input_widget.dart';
import 'package:neosurge_fe/features/auth/controller/profile_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
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
                'Login to continue',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  final res =
                      await ref.read(profileController.notifier).loginUser(
                            context: context,
                            email: _emailController.text,
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
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
