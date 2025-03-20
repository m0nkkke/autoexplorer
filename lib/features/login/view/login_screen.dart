import 'package:autoexplorer/features/login/widgets/input_field.dart';
import 'package:autoexplorer/features/login/widgets/login_button.dart';
import 'package:autoexplorer/features/login/widgets/logo_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accessKeyController = TextEditingController();
    final passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>(); 

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Form(
            key: _formKey, // Привязка ключа к форме
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LogoWidget(),
                const SizedBox(height: 32),
                InputField(
                  labelText: 'Ключ доступа',
                  hintText: 'Например: F3A0ETbfjPs4kIP',
                  controller: accessKeyController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите ключ доступа';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InputField(
                  labelText: 'Пароль',
                  hintText: 'Например: 123qwe',
                  controller: passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите пароль';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                LoginButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Если форма валидна
                      String accessKey = accessKeyController.text;
                      String password = passwordController.text;
                      // Логика авторизации
                      print('Access Key: $accessKey');
                      print('Password: $password');
                      Navigator.of(context).pushNamed('/');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
