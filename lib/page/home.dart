import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<bool> toggleList = [false, false];
  final List<String> toggleTitle = ['Cellular data', 'Wi-Fi'];

  int notifications = 0;
  final List<String> radioTitle = [
    'Allow notifications',
    'Turn off notifications',
  ];

  List<bool> checkList = [false, false, false];
  final List<String> checkTitle = [
    'Microphone access',
    'Location access',
    'Haptics',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: content());
  }

  Widget content() => SafeArea(
    child: SingleChildScrollView(
      physics: RangeMaintainingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          toggle(),
          const SizedBox(height: 30),
          radio(),
          const SizedBox(height: 30),
          check(),
        ],
      ),
    ),
  );

  Widget check() => Column(
    crossAxisAlignment: .start,
    children: [
      Padding(
        padding: const .only(left: 15),
        child: Text(
          'Multiple check',
          style: TextStyle(
            color: Colors.black,
            fontWeight: .w600,
            fontSize: 18,
          ),
        ),
      ),
      const SizedBox(height: 15),
      Column(
        children: .generate(3, (index) {
          return checkItem(index);
        }),
      ),
    ],
  );

  Widget checkItem(index) => Column(
    children: [
      CheckboxListTile(
        activeColor: Colors.blue,
        title: Text(
          checkTitle[index],
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        value: checkList[index],
        onChanged: (value) {
          checkList[index] = !checkList[index];
          setState(() {});
        },
      ),
      Divider(
        height: 1,
        // 선 공간
        thickness: 1,
        // 선 두께,
        indent: 20,
        // 왼쪽 패딩
        endIndent: 20,
        // 왼쪽 패딩
        color: index == 2 ? Colors.white : Colors.grey[300],
      ),
    ],
  );

  Widget radio() => Column(
    crossAxisAlignment: .start,
    children: [
      Padding(
        padding: const .only(left: 15),
        child: Text(
          'Single check',
          style: TextStyle(
            color: Colors.black,
            fontWeight: .w600,
            fontSize: 18,
          ),
        ),
      ),
      const SizedBox(height: 15),
      Column(
        children: .generate(2, (index) {
          return radioItem(index);
        }),
      ),
    ],
  );

  Widget radioItem(index) => Column(
    children: [
      RadioListTile(
        activeColor: Colors.blue,
        controlAffinity: .trailing,
        value: index,
        // 버튼 고유 번호
        groupValue: notifications,
        // 그
        onChanged: (value) {
          notifications = value;
          setState(() {});
        },
        title: Text(
          radioTitle[index],
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      Divider(
        height: 1,
        // 선 공간
        thickness: 1,
        // 선 두께,
        indent: 20,
        // 왼쪽 패딩
        endIndent: 20,
        // 왼쪽 패딩
        color: Colors.grey[300],
      ),
    ],
  );

  Widget toggle() => Column(
    crossAxisAlignment: .start,
    children: [
      Padding(
        padding: const .only(left: 15),
        child: Text(
          'Toggle',
          style: TextStyle(
            color: Colors.black,
            fontWeight: .w600,
            fontSize: 18,
          ),
        ),
      ),
      const SizedBox(height: 15),
      Column(
        children: .generate(2, (index) {
          return toggleItem(index);
        }),
      ),
    ],
  );

  Widget toggleItem(index) => Column(
    children: [
      Theme(
        data: ThemeData(
          useMaterial3: false, // 에전 Material 디자인 써야함
        ),
        child: SwitchListTile(
          activeTrackColor: Colors.blue[200],
          // 활성화 시 Switch 버튼 박스 컬러
          inactiveTrackColor: Colors.grey[400],
          // 비활성화 시 Switch 버튼 박스 컬러
          inactiveThumbColor: Colors.white,
          // 비활성화 시 Switch 버튼 컬러
          activeThumbColor: Colors.blue[600],
          // 활성화 시 Switch 버튼 컬러
          title: Text(
            toggleTitle[index],
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          value: toggleList[index],
          onChanged: (bool value) {
            toggleList[index] = !toggleList[index];
            print(value);
            setState(() {});
          },
        ),
      ),
      Divider(
        height: 1.2,
        // 선 공간
        thickness: 1.2,
        // 선 두께,
        indent: 20,
        // 왼쪽 패딩
        endIndent: 20,
        // 왼쪽 패딩
        color: Colors.grey[300],
      ),
    ],
  );

  AppBar appBar() => AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.blueAccent,
      statusBarIconBrightness: .light,
    ),
    toolbarHeight: 70,
    backgroundColor: Colors.lightBlueAccent,
    title: Text(
      'Settings',
      style: TextStyle(color: Colors.white, fontWeight: .w700, fontSize: 26),
    ),
  );
}
