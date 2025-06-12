import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginRichtext extends StatelessWidget {
  const LoginRichtext({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.nunito(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Khi nhấn \'Tạo tài khoản\' hoặc \'Đăng nhập\', bạn\n ',
            style: textStyle,
          ),
          TextSpan(text: 'đồng ý với các ', style: textStyle),
          TextSpan(
            text: 'Điều khoản ',
            style: textStyle.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
          TextSpan(text: 'của chúng tôi. Tìm\n ', style: textStyle),
          TextSpan(
            text: 'hiểu cách chúng tôi xử lý dữ liệu của bạn trong\n',
            style: textStyle,
          ),
          TextSpan(
            text: 'Chính sách Quyền riêng tư',
            style: textStyle.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
          TextSpan(text: ' và ', style: textStyle),
          TextSpan(
            text: 'Chính sách Cookie\n',
            style: textStyle.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
          TextSpan(text: 'của chúng tôi.', style: textStyle),
        ],
      ),
    );
  }
}
