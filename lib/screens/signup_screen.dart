import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';

import '../resources/auth_methods.dart';

class SignUpcreen extends StatefulWidget {
  const SignUpcreen({super.key});

  @override
  State<SignUpcreen> createState() => _SignUpcreenState();
}

class _SignUpcreenState extends State<SignUpcreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameComtroller = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameComtroller.dispose();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void signupUser() async {
    setState(() {
      _isLoading = true;
    });
    await AuthMethods()
        .signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameComtroller.text,
      bio: _bioController.text,
      file: _image!,
    )
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res != "success") {
        showSnackBar(context, res);
      }
    });
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
              Flexible(
                flex: 2,
                child: Container(),
              ),
              //instagram brand image
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                colorFilter:
                    const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              //circular widget to show and select the picture
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              "https://img.freepik.com/free-icon/user_318-563642.jpg?w=360"),
                        ),
                  Positioned(
                      left: 80,
                      bottom: -10,
                      child: IconButton(
                        onPressed: () {
                          selectImage();
                        },
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              //user name field
              TextInputField(
                textEditingController: _usernameComtroller,
                hintText: "Enter your user name",
                textInputType: TextInputType.text,
                isPass: false,
              ),
              const SizedBox(
                height: 24,
              ),
              //email field
              TextInputField(
                textEditingController: _emailController,
                hintText: "Enter your email",
                textInputType: TextInputType.emailAddress,
                isPass: false,
              ),
              const SizedBox(
                height: 24,
              ),
              //password field
              TextInputField(
                textEditingController: _passwordController,
                hintText: "Enter your password",
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              //bio field
              TextInputField(
                textEditingController: _bioController,
                hintText: "Enter your bio",
                textInputType: TextInputType.text,
                isPass: false,
              ),
              const SizedBox(
                height: 32,
              ),
              //signup button
              InkWell(
                onTap: signupUser,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: blueColor,
                        ),
                        child: const Text("Sign Up"),
                      ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              //switch screen to login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Already have an account?"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Log in",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
}
