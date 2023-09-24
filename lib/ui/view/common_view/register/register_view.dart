import 'package:flutter/material.dart';
import 'package:project_order_food/ui/router.dart';
import 'package:project_order_food/ui/shared/app_color.dart';
import 'package:project_order_food/ui/shared/ui_helpers.dart';
import 'package:project_order_food/ui/view/common_view/register/controllers/register_controller.dart';
import 'package:project_order_food/ui/widget/a_button.dart';
import 'package:project_order_food/ui/widget/form/a_text_form_field.dart';
import 'package:project_order_food/core/extension/validation.dart';
import 'package:project_order_food/ui/shared/a_image.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final RegisterController controller = RegisterController();
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
                  UIHelper.verticalSpaceLarge(),
                  ATextFormField(
                    label: 'Email',
                    onSaved: (v) => controller.email = v,
                    validator: (v) =>
                        v!.isEmpty || !v.isValidEmail ? 'Invalid email' : null,
                  ),
                  UIHelper.verticalSpaceMedium(),
                  ATextFormField(
                    label: 'Password',
                    obscureText: true,
                    onChanged: (v) => controller.password = v,
                    onSaved: (v) => controller.password = v,
                  ),
                  UIHelper.verticalSpaceMedium(),
                  ATextFormField(
                    label: 'Confirm password',
                    obscureText: true,
                    validator: (v) => v!.isEmpty || v != controller.password
                        ? 'Passwords do not match'
                        : null,
                  ),
                  UIHelper.verticalSpaceMedium(),
                  AButton.text(
                    'Sign up',
                    isExpanded: true,
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        _key.currentState!.save();
                        controller.signUp();
                      }
                    },
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  UIHelper.verticalSpaceMedium(),
                  AButton.text(
                    'Back',
                    isExpanded: true,
                    color: AColor.red,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, RoutePaths.loginView);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
