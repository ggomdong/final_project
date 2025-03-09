import 'package:final_project/constants/gaps.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/view_models/login_view_model.dart';
import 'package:final_project/view_models/social_auth_view_model.dart';
import 'package:final_project/views/sign_up_screen.dart';
import 'package:final_project/views/widgets/common_app_bar.dart';
import 'package:final_project/views/widgets/auth_button.dart';
import 'package:final_project/views/widgets/form_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static const routeUrl = "/";
  static const routeName = "login";

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  Map<String, String> formData = {};

  // Keyboard 외의 영역 클릭시 Keyboard가 사라지도록 처리
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  // password 비식별 처리 토글
  void _toggleObscureText() {
    _obscureText = !_obscureText;
    setState(() {});
  }

  void _onSubmitForm() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ref.read(loginProvider.notifier).login(
              formData["email"]!,
              formData["password"]!,
              context,
            );
      }
    }
  }

  void _onSignUpTap() {
    context.pushNamed(SignUpScreen.routeName);
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
                    "Welcome!",
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
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        formData['email'] = value;
                      }
                    },
                  ),
                  Gaps.v10,
                  TextFormField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _toggleObscureText,
                            child: FaIcon(
                              _obscureText
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
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        formData['password'] = value;
                      }
                    },
                  ),
                  Gaps.v16,
                  FormButton(
                    disabled: ref.watch(loginProvider).isLoading,
                    text: "Enter",
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
              text: "Create an account →",
              onTap: _onSignUpTap,
            ),
          ),
        ),
      ),
    );
  }
}
