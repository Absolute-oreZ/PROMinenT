import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);
  
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  //to validate email
  /*
  *    Title        : EmailValidator
  *    Author       : Airon Tark,Philippe Fanaro
  *    Date         : 7/1/2024
  *    Code version : 1.0
  *    Availability : https://stackoverflow.com/questions/16800540/how-should-i-check-if-the-input-is-an-email-address-in-flutter
  */
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }

    if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null; // Return null if the validation succeeds
  }

  Future _logIn() async {
    if (_formKey.currentState!.validate()) {
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => const Center(
      //         child: CircularProgressIndicator(),
      //       ));

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
      } on FirebaseAuthException catch (e) {
        print(e);
      }
      // navigatorKey.currentState!.popUntil((route) => route.isCurrent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/images/PROMinenT Logo.png",width: 250,),
              const SizedBox(
                height: 35,
              ),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.email,
                    size: 30,
                    color: Colors.white,
                  ),
                  labelText: 'Email',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'Enter your email',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color.fromRGBO(206, 212, 221, 1),
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                validator: (value) => _validateEmail(value),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: passwordController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.password,
                      size: 30,
                      color: Colors.white,
                    ),
                    labelText: 'Password',
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    hintText: 'Enter your password',
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color.fromRGBO(206, 212, 221, 1),
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold);
                      return 'Required!';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(
                  Icons.lock_open,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: _logIn,
                label: const Text(
                  'Log In',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
