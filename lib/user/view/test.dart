import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';


void main() => runApp(const MaterialApp(
  home: SymptomRegistration(),
));

class SymptomRegistration extends StatelessWidget {
  const SymptomRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return const DefaultLayout(

        child: Padding(
          padding: EdgeInsets.all(14.0),
          child: Column(
            children: [
              Row(
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
                  Text("Symptom",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: SUB_TEXT_COLOR,
                      ))
                ],
              ),
              RadioButtonWidget(),
              // Row(
              //   children: [
              //     // RadioButtonWidget(),
              //
              //   ],
              // )
            ],
          ),
        ));
  }
}

enum SymptomName { Symptom1, Symptom2, Symptom3, Symptom4 }

/// This is the stateful widget that the main application instantiates.
class RadioButtonWidget extends StatefulWidget {
  const RadioButtonWidget({Key? key}) : super(key: key);

  @override
  State<RadioButtonWidget> createState() => _RadioButtonWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _RadioButtonWidgetState extends State<RadioButtonWidget> {
//처음에는 사과가 선택되어 있도록 Apple로 초기화 -> groupValue에 들어갈 값!
  SymptomName? _symptom = SymptomName.Symptom1;

  @override
  Widget build(BuildContext context) {
    return Column(

      children: <Widget>[
        ListTile(
          //ListTile - title에는 내용,
          //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
          title: const Text("두근거림"),
          leading: Radio<SymptomName>(
            value: SymptomName.Symptom1,
            groupValue: _symptom,
            onChanged: (SymptomName? value) {
              setState(() {
                _symptom = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('불안감'),
          leading: Radio<SymptomName>(
            value: SymptomName.Symptom2,
            groupValue: _symptom,
            onChanged: (SymptomName? value) {
              setState(() {
                _symptom = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('어지러움'),
          leading: Radio<SymptomName>(
            value: SymptomName.Symptom3,
            groupValue: _symptom,
            onChanged: (SymptomName? value) {
              setState(() {
                _symptom = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('흉통 또는 불편감'),
          leading: Radio<SymptomName>(
            value: SymptomName.Symptom4,
            groupValue: _symptom,
            onChanged: (SymptomName? value) {
              setState(() {
                _symptom = value;
              });
            },
          ),
        ),
        ListTile(
          //ListTile - title에는 내용,
          //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
          title: const Text("두근거림"),
          leading: Radio<SymptomName>(
            value: SymptomName.Symptom1,
            groupValue: _symptom,
            onChanged: (SymptomName? value) {
              setState(() {
                _symptom = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('불안감'),
          leading: Radio<SymptomName>(
            value: SymptomName.Symptom2,
            groupValue: _symptom,
            onChanged: (SymptomName? value) {
              setState(() {
                _symptom = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('어지러움'),
          leading: Radio<SymptomName>(
            value: SymptomName.Symptom3,
            groupValue: _symptom,
            onChanged: (SymptomName? value) {
              setState(() {
                _symptom = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('흉통 또는 불편감'),
          leading: Radio<SymptomName>(
            value: SymptomName.Symptom4,
            groupValue: _symptom,
            onChanged: (SymptomName? value) {
              setState(() {
                _symptom = value;
              });
            },
          ),
        ),


      ],
    );

  }
}


// import 'package:flutter/material.dart';
//
// void main() => runApp(MaterialApp(
//   home: AddItemApp(),
// ));
//
// class AddItemApp extends StatefulWidget {
//   @override
//   _AddItemAppState createState() => _AddItemAppState();
// }
//
// class _AddItemAppState extends State<AddItemApp> {
//   List<String> items = [];
//   String newItem = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Items'),
//       ),
//       body: ListView.builder(
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(items[index]),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text('Add New Item'),
//                 content: TextField(
//                   onChanged: (value) {
//                     newItem = value;
//                   },
//                 ),
//                 actions: [
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         items.add(newItem);
//                       });
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('Add'),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
