import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/routes.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  String name = "";
  bool ChangeButton = false;
  final _formkey = GlobalKey<FormState>();

  movetohome(BuildContext context) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        ChangeButton = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      await Navigator.pushNamed(context, MyRoutes.homeRoute);
      setState(() {
        ChangeButton = false;
      });
    }
  }

  void createAccount() async {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();
    if (email == "" ||
        name == "" ||
        phone == "" ||
        password == "" ||
        cPassword == "") {
      log("Please fill all the details");
    } else if (password != cPassword) {
      log("Passwords do not match");
    } else {
      try {
        //create new acc
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          Navigator.pushNamed(context, MyRoutes.loginRoute);
        }
        log("User created successfully");
      } on FirebaseAuthException catch (ex) {
        log(ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.canvasColor,
      body: SafeArea(
        child: Container(
          padding: Vx.m32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "Sign Up".text.xl5.bold.color(context.theme.accentColor).make(),
              "Create your account".text.xl2.make(),
              CupertinoFormSection(
                  header: "Personal Details".text.make(),
                  children: [
                    CupertinoFormRow(
                      prefix: "Name".text.make(),
                      child: CupertinoTextFormFieldRow(
                          placeholder: "Enter name",
                          controller: nameController),
                    ),
                    CupertinoFormRow(
                      prefix: "Phone".text.make(),
                      child: CupertinoTextFormFieldRow(
                          placeholder: "Enter phone",
                          controller: phoneController),
                    )
                  ]),
              CupertinoFormSection(header: "User".text.make(), children: [
                CupertinoFormRow(
                  prefix: "Email".text.make(),
                  child: CupertinoTextFormFieldRow(
                      placeholder: "Enter email", controller: emailController),
                ),
                CupertinoFormRow(
                  prefix: "Password".text.make(),
                  child: CupertinoTextFormFieldRow(
                      controller: passwordController, obscureText: true),
                ),
                CupertinoFormRow(
                  prefix: "Confirm Password".text.make(),
                  child: CupertinoTextFormFieldRow(
                      controller: cPasswordController, obscureText: true),
                )
              ]),
              CupertinoFormSection(
                  header: "Terms & Conditions".text.make(),
                  children: [
                    CupertinoFormRow(
                      prefix: "I Agree".text.make(),
                      child: CupertinoSwitch(
                        value: true,
                        onChanged: (value) {},
                      ),
                    ),
                  ]),
              20.heightBox,
              Material(
                borderRadius: BorderRadius.circular(ChangeButton ? 50 : 8),
                color: context.theme.buttonColor,
                child: InkWell(
                  onTap: (() {
                    createAccount();
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: ChangeButton ? 50 : 150,
                    height: 50,
                    alignment: Alignment.center,
                    child: ChangeButton
                        ? const Icon(Icons.done, color: Colors.white)
                        : const Text("SignUp",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ).centered(),
            ],
          ),
        ),
      ),
    );
  }
}
