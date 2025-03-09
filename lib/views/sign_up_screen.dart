import 'package:final_project/constants/gaps.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/view_models/sign_up_view_model.dart';
import 'package:final_project/view_models/social_auth_view_model.dart';
import 'package:final_project/views/widgets/auth_button.dart';
import 'package:final_project/views/widgets/common_app_bar.dart';
import 'package:final_project/views/widgets/form_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});
  static const routeUrl = "/signUp";
  static const routeName = "signUp";

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  bool _obscurePw1 = true;
  bool _obscurePw2 = true;

  // Keyboard 외의 영역 클릭시 Keyboard가 사라지도록 처리
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  // email 유효성 체크
  bool _isEmailValid(String email) {
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regExp.hasMatch(email);
  }

  // password 유효성 체크(자리수)
  bool _isPasswordValid(String password) {
    return password.length >= 8;
  }

  // password 유효성 체크(일치)
  bool _isPasswordMatch() {
    return _password == _confirmPassword;
  }

  // password 비식별 처리 토글
  void _toggleObscurePw1() {
    _obscurePw1 = !_obscurePw1;
    setState(() {});
  }

  void _toggleObscurePw2() {
    _obscurePw2 = !_obscurePw2;
    setState(() {});
  }

  void _onSubmitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref.read(signUpForm.notifier).state = {
        "email": _email,
        "password": _password
      };
      ref.read(signUpProvider.notifier).signUp(context);
    }
  }

  void _onLogInTap() {
    context.pop();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CommonAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.size64,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Gaps.v96,
                  Text(
                    "Join!",
                    style: TextStyle(
                      fontSize: Sizes.size20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Gaps.v32,
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Sizes.size14,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        fontSize: Sizes.size18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                        color: Colors.grey.shade400,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                        borderSide: BorderSide(
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!_isEmailValid(value)) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() => _email = value),
                    onSaved: (value) {
                      if (value != null) {
                        _email = value;
                      }
                    },
                  ),
                  Gaps.v10,
                  TextFormField(
                    obscureText: _obscurePw1,
                    decoration: InputDecoration(
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _toggleObscurePw1,
                            child: FaIcon(
                              _obscurePw1
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              color: Colors.grey.shade500,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Sizes.size14,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontSize: Sizes.size18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                        color: Colors.grey.shade400,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                        borderSide: BorderSide(
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a password';
                      }
                      if (!_isPasswordValid(value)) {
                        return 'Password must be at least 8 characters';
                      }
                      if (!_isPasswordMatch()) {
                        return 'Password must be matched';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() => _password = value),
                    onSaved: (value) {
                      if (value != null) {
                        _password = value;
                      }
                    },
                  ),
                  Gaps.v10,
                  TextFormField(
                    obscureText: _obscurePw2,
                    decoration: InputDecoration(
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _toggleObscurePw2,
                            child: FaIcon(
                              _obscurePw1
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              color: Colors.grey.shade500,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Sizes.size14,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(
                        fontSize: Sizes.size18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                        color: Colors.grey.shade400,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                        borderSide: BorderSide(
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a password';
                      }
                      if (!_isPasswordValid(value)) {
                        return 'Password must be at least 8 characters';
                      }
                      if (!_isPasswordMatch()) {
                        return 'Password must be matched';
                      }
                      return null;
                    },
                    onChanged: (value) =>
                        setState(() => _confirmPassword = value),
                    onSaved: (value) {
                      if (value != null) {
                        _confirmPassword = value;
                      }
                    },
                  ),
                  Gaps.v16,
                  FormButton(
                    disabled: !(_isEmailValid(_email) &&
                        _isPasswordValid(_password) &&
                        _isPasswordMatch() &&
                        !ref.watch(signUpProvider).isLoading),
                    text: "Create Account",
                    onTap: _onSubmitForm,
                  ),
                  Gaps.v32,
                  GestureDetector(
                    onTap: () => ref
                        .read(socialAuthProvider.notifier)
                        .githubSignIn(context),
                    child: AuthButton(
                      icon: FaIcon(
                        FontAwesomeIcons.github,
                        size: Sizes.size24,
                      ),
                      text: "Continue with Github",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size44,
            vertical: Sizes.size48,
          ),
          child: Container(
            padding: EdgeInsets.all(
              Sizes.size20,
            ),
            child: FormButton(
              disabled: false,
              text: "Log in →",
              onTap: _onLogInTap,
            ),
          ),
        ),
      ),
    );
  }
}
