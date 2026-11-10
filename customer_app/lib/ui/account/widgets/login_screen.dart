import 'package:flutter/material.dart';

import '../../core/app_name.dart';
import '../../core/tokens.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/primary_button.dart';
import '../view_models/login_view_model.dart';
import 'join_banner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() =>
      widget.viewModel.login(email: _email.text, password: _password.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpace.gutter,
                8,
                AppSpace.gutter,
                28,
              ),
              child: Text('$appName에\n로그인해 주세요', style: AppText.title),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpace.gutter),
              // 오류 문구와 버튼만 바뀌니, 이 부분만 다시 그린다.
              child: ListenableBuilder(
                listenable: widget.viewModel,
                // 비밀번호 관리 앱이 이메일과 비밀번호를 함께 채울 수 있게 묶는다.
                builder: (context, _) => AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      LabeledField(
                        label: '이메일 아이디',
                        child: TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: [
                            AutofillHints.username,
                            AutofillHints.email,
                          ],
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: 'hana@email.com',
                          ),
                        ),
                      ),
                      LabeledField(
                        label: '비밀번호',
                        child: TextField(
                          controller: _password,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          autofillHints: [AutofillHints.password],
                          onSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            hintText: '비밀번호를 입력해 주세요.',
                            errorText: widget.viewModel.error,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: PrimaryButton(
                          label: '로그인',
                          onPressed: _submit,
                          loading: widget.viewModel.submitting,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _FindLinks(),
            // TODO: SNS 로그인
            SizedBox(height: 24),
            JoinBanner(),
          ],
        ),
      ),
    );
  }
}

class _FindLinks extends StatelessWidget {
  const _FindLinks();

  @override
  Widget build(BuildContext context) {
    final style = AppText.label.copyWith(color: AppColors.textSecondary);
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {}, // TODO: 아이디 찾기
            child: Text('아이디 찾기', style: style),
          ),
          TextButton(
            onPressed: () {}, // TODO: 비밀번호 찾기
            child: Text('비밀번호 찾기', style: style),
          ),
        ],
      ),
    );
  }
}
