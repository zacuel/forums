//TODO STYLING

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/http_exception.dart';

enum AuthMode { signUp, logIn }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.signUp;
  //TODO isLoading variable.
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    try {
      if (_authMode == AuthMode.signUp) {
        //TODO rename AuthProvider to Auth
        await Provider.of<Auth>(context,
                listen:
                    false) //This context needs to be what the build context is
            .createAccount(_authData['email']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .logIn(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = "email already in use";
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'bad email dude';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'make your password more mighty, moron.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'you\'re not on the list';
      } else if (errorMessage.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'wrong password buddy';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'didn\'t work, don\'t know why, try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: ((ctx) => AlertDialog(
              title: const Text('error occured'),
              content: Text(message),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text("ok"))
              ],
            )));
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.logIn) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.logIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_authMode == AuthMode.logIn ? "Log In" : "Sign Up"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  //TODO better email validation
                  return 'Invalid email!';
                }
                return null;
              },
              onSaved: (value) {
                _authData['email'] = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'password'),
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                //TODO make my validation match firebase
                if (value!.isEmpty || value.length < 5) {
                  return 'Password is too short!';
                }
                return null;
              },
              onSaved: (value) {
                _authData['password'] = value!;
              },
            ),
            if (_authMode == AuthMode.signUp)
              TextFormField(
                enabled: _authMode == AuthMode.signUp,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: _authMode == AuthMode.signUp
                    ? (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match!';
                        }
                        return null;
                      }
                    : null,
              ),
            ElevatedButton(
              onPressed: _submit,
              child: Text('proceed'),
            ),
            TextButton(
              onPressed: _switchAuthMode,
              child: Text(_authMode == AuthMode.signUp
                  ? "Have an Account?"
                  : "Need an Account?"),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }
}
