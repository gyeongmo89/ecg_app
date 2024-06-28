import 'package:ecg_app/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final bool isTime;
  final FormFieldSetter<String> onSaved;
  const CustomTextField({
    required this.isTime,
    required this.label,
    required this.onSaved,
    required this.initialValue,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.notes,
              color: Colors.black,
              size: 22.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width/30,
            ),
            Text(
              label,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: BODY_TEXT_COLOR,
                ),
            ),
          ],
        ),
        if (isTime) renderTextField(),
        if (!isTime)
          Expanded(
            child: renderTextField(),
          )
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField(
      onSaved: onSaved,
      cursorColor: Colors.grey,
      maxLines: isTime ? 1 : null,
      // null이면 자동 줄바꿈 1은 라인 수, isTime을 False로 갖고 오기 때문에 자동 줄 바꿈으로 설정됨
      expands: !isTime,
      initialValue: initialValue, //
      maxLength: 50, // 글자 50자 제한
      // keyboardType: TextInputType.number,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime
          ? [
              FilteringTextInputFormatter.digitsOnly, // 시작시간에 숫자만 넣을 수 있도록
            ]
          : [],
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
        suffixText: isTime? "시" : null,  // 접미사
      ),
    );
  }
}
