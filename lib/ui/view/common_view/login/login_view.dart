import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_order_food/core/service/get_navigation.dart';
import 'package:project_order_food/locator.dart';
import 'package:project_order_food/ui/router.dart';
import 'package:project_order_food/ui/shared/app_color.dart';
import 'package:project_order_food/ui/shared/ui_helpers.dart';
import 'package:project_order_food/ui/view/common_view/login/controllers/login_controller.dart';
import 'package:project_order_food/ui/view/common_view/register/register_view.dart';
import 'package:project_order_food/ui/widget/a_button.dart';
import 'package:project_order_food/ui/widget/form/a_text_form_field.dart';
import 'package:project_order_food/core/extension/validation.dart';
import 'package:project_order_food/ui/shared/a_image.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final LoginController controller = LoginController();

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => locator<GetNavigation>()
            .replaceTo(RoutePaths.loadingView, arguments: RoutePaths.uHomeView),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  Image.asset(AImage.logo),
                  UIHelper.verticalSpaceMedium(),
                  ATextFormField(
                    label: 'Email',
                    validator: (v) =>
                        v!.isEmpty || !v.isValidEmail ? 'Invalid email' : null,
                    onSaved: (v) => controller.userName = v,
                  ),
                  UIHelper.verticalSpaceMedium(),
                  ATextFormField(
                    label: 'Password',
                    obscureText: true,
                    onSaved: (v) => controller.password = v,
                  ),
                  UIHelper.verticalSpaceMedium(),
                  AButton.text(
                    'Login',
                    isExpanded: true,
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        _key.currentState!.save();
                        controller.signIn(
                          context,
                        );
                      }
                    },
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  UIHelper.verticalSpaceSmall(),
                  AButton.text(
                    'Sign up',
                    isExpanded: true,
                    color: AColor.textGreen,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => RegisterView()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
