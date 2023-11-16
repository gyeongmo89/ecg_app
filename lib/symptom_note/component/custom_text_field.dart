import 'package:ecg_app/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue;

  // true - 시간 / false - 내용
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
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR2,
            // color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isTime) renderTextField(),
        if (!isTime)
          Expanded(
            child: renderTextField(),
          ) // 내용 텍스트 필드 최대화 하기위해서
      ],
    );
  }

  Widget renderTextField() {
    // return TextField(
    return TextFormField(
      onSaved: onSaved,
      // Form을 통해서 Input을 동시에 관리함
      // onChanged는 null 값이 들어갈 수 있는 string이 파라미터로 반환됨
      // onChanged: (String? val){
      // onChanged는 필요없다 validator로 변환
      // },
      // null이 return 되면 에러가 없다, 에러가 있으면 에러를 String 값으로 리턴해준다.
      //--------- 2023-11-16 주석처리함 / 필수값 제외 ----
      // validator: (String? val) {
      //   if (val == null || val.isEmpty) {
      //     return "기타 설명을 입력해 주세요";
      //   }
      //
      //   if (isTime) {
      //     int time = int.parse(val); // string값을 int로 바꿈., 값이 무조건 있으니까 !넣음
      //
      //     if (time < 0) {
      //       return "0 이상의 숫자를 입력해주세요";
      //     }
      //     if (time > 24) {
      //       return "24 이하의 숫자를 입력해주세요";
      //     }
      //   } else {
      //     if(val.length > 100){   // 글자 100자 제한
      //       return "100자 이하의 글자를 입력해주세요";
      //     }
      //   }
      //
      //   return null;
      // },
      //---------
      cursorColor: Colors.grey,
      maxLines: isTime ? 1 : null,
      // null이면 자동 줄바꿈, 1은 라인 수
      expands: !isTime,
      initialValue: initialValue, //
      // maxLength: 100, // 글자 500자 제한
      // = isTime ? false : true 이랑 똑같음
      // keyboardType: TextInputType.number,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime
          ? [
              FilteringTextInputFormatter.digitsOnly, // 시작시간에 숫바만 넣을 수 있도록
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
