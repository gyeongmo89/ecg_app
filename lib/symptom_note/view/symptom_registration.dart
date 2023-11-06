import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class SymptomRegistration extends StatefulWidget {
  const SymptomRegistration({Key? key}) : super(key: key);

  @override
  _SymptomRegistrationState createState() => _SymptomRegistrationState();
}

class _SymptomRegistrationState extends State<SymptomRegistration> {
  int groupValue = 0; // 선택된 라디오 버튼 그룹을 식별하는 변수

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return DefaultLayout(
      title: "Symptom Note",
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Registration",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: BODY_TEXT_COLOR,
                  ),
                ),
                Text(
                  "Symptom",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: SUB_TEXT_COLOR,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Add some space between the text and radio buttons
            Row(
              children: [
                Radio(
                  value: 1, // Use integer value
                  groupValue: groupValue,
                  onChanged: (value) {
                    // Handle radio button selection
                    setState(() {
                      groupValue = value!;
                    });
                  },
                ),
                const Text("Option 1"),
                Radio(
                  value: 2, // Use a different integer value
                  groupValue: groupValue,
                  onChanged: (value) {
                    // Handle radio button selection
                    setState(() {
                      groupValue = value!;
                    });
                  },
                ),
                const Text("Option 2"),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 3, // Use a different integer value
                  groupValue: groupValue,
                  onChanged: (value) {
                    // Handle radio button selection
                    setState(() {
                      groupValue = value!;
                    });
                  },
                ),
                const Text("Option 3"),
                Radio(
                  value: 4, // Use a different integer value
                  groupValue: groupValue,
                  onChanged: (value) {
                    // Handle radio button selection
                    setState(() {
                      groupValue = value!;
                    });
                  },
                ),
                const Text("Option 4"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
