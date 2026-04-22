import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<bool> toggleList = [false, false];
  final List<String> toggleTitle = ['Cellular data', 'Wi-Fi'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: content());
  }

  Widget content() => SafeArea(
    child: SingleChildScrollView(
      physics: RangeMaintainingScrollPhysics(),
      child: Column(children: [const SizedBox(height: 20), toggle()]),
    ),
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

  Widget toggleItem(index) => Theme(
    data: ThemeData(
      useMaterial3: false // 에전 Material 디자인 써야함
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
