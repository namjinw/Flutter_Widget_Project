import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget/model/todo_list.dart';

class Widget1Page extends StatefulWidget {
  const Widget1Page({super.key});

  @override
  State<Widget1Page> createState() => _Widget1PageState();
}

class _Widget1PageState extends State<Widget1Page> {
  final TextEditingController _controller = TextEditingController();
  bool checked = false;

  List<TodoList> todoList = [];

  String _buildNumberedTodoText() {
    final titles = todoList
        .map((todo) => todo.title.trim()) // 요소 순회 하면서 title.trim만 뽑기
        .toList(); // 리스트화

    if (todoList.isEmpty) return '할 일이 없습니다.'; // 이거 추가

    return titles
        .asMap() // 리스트(List)를 맵(Map) 형태로 잠시 변환
        .entries // 키와 값 쌍으로 묶어서 출력
        .map((entry) => '${entry.key + 1}. ${entry.value}')
         // 각각 요소들을 순회하며 이런식으로 출력
        .join('\n'); // 하나의 텍스트로 합치기
  }

  void makeTodoList(String title) {
    todoList.add(TodoList(title: title.trim(), checked: false));
    _controller.text = '';
    FocusScope.of(context).unfocus();
    setState(() {});
    print(todoList.length);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              '앱을 종료하시겠습니까?',
              style: TextStyle(
                color: Colors.black,
                fontWeight: .w700,
                fontSize: 18,
              ),
            ),
            actionsAlignment: .center,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '닫기',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: .w700,
                    fontSize: 18,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final content = _buildNumberedTodoText();
                  print(content);

                  await MethodChannel('todo').invokeMethod('notification', {
                    'count': todoList.length,
                    'content': content,
                  });

                  SystemNavigator.pop();
                },
                child: Text(
                  '종료하기',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: .w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: appBar(),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(child: content()),
      ),
    );
  }

  // Widget check() => SafeArea(
  //   child: Column(
  //     children: [
  //       Checkbox(
  //         // activeColor: Colors.red, 체크 될때 색깔
  //         // shape: RoundedRectangleBorder(
  //         //   borderRadius: .circular(10)
  //         // ), 체크 박스 모양 변경
  //         // visualDensity: VisualDensity.compact,  // 위젯 패딩, 간격 조절
  //         // checkColor: Colors.blue, // 체크 아이콘 색깔
  //         //   fillColor: WidgetStateProperty.fromMap({ 한 번에 상태별 스타일을 선언적으로 정의할 때
  //         //     WidgetState.selected: Colors.red, // 선택될 때 색깔
  //         //     WidgetState.disabled: Colors.green, // 비활성 색깔
  //         //     WidgetState.pressed: Colors.green, // 누를때 색깔
  //         //     WidgetState.hovered: Colors.red, // 마우스 호버 색깔
  //         //     WidgetState.focused: Colors.green // 포커스 색깔
  //         //   }),
  //         // splashRadius: 30, 클릭 스플래쉬 효과 크기
  //         value: checked,
  //         onChanged: (bool? value) {
  //           checked = value!;
  //           setState(() {});
  //         },
  //       ),
  //     ],
  //   ),
  // );

  Widget content() => SizedBox(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        spacing: 5,
        crossAxisAlignment: .start,
        children: [
          Divider(height: 1, color: Colors.grey),
          Text(
            'To do List',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: .w700,
            ),
          ),

          // Container(height: 500, color: Colors.red),
          //
          // Container(height: 500, color: Colors.blue),
          cardList(),
          section(),
        ],
      ),
    ),
  );

  Widget cardList() => SizedBox(
    height: 450,
    child: ListView(
      physics: RangeMaintainingScrollPhysics(),
      children: .generate(
        todoList.length,
        (index) => todoListItem(todoList[index], index),
      ),
    ),
  );

  Widget section() => Container(
    decoration: BoxDecoration(
      border: .fromLTRB(top: BorderSide(width: 1, color: Colors.black)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            'Completed Todos: ${todoList.length}',
            style: TextStyle(
              fontWeight: .w700,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          buttons(),
        ],
      ),
    ),
  );

  Widget buttons() => Row(
    children: [
      buttonItem(() {
        todoList.clear();
        setState(() {});
      }, 'clear All'),
    ],
  );

  Widget buttonItem(ontap, text) => GestureDetector(
    onTap: ontap,
    child: Container(
      padding: .symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xffadbdc8),
        borderRadius: .circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: .w700),
      ),
    ),
  );

  Widget todoListItem(TodoList todo, index) => Container(
    margin: .only(bottom: 5),
    width: MediaQuery.sizeOf(context).width,
    height: 50,
    decoration: BoxDecoration(border: .all(color: Colors.grey, width: 1.5)),
    child: Row(
      children: [
        Expanded(
          child: CheckboxListTile(
            visualDensity: VisualDensity(vertical: -4),
            activeColor: Colors.blueAccent,
            controlAffinity: .leading,
            title: Text(
              todo.title,
              style: TextStyle(
                color: todo.checked ? Colors.grey : Colors.black,
                fontSize: 20,
                fontWeight: .w600,
                decorationThickness: 2,
                decoration: todo.checked ? .lineThrough : .none,
              ),
            ),
            value: todo.checked,
            onChanged: (value) {
              todo.checked = value!;
              setState(() {});
            },
          ),
        ),
        IconButton(
          onPressed: () {
            todoList.remove(todoList[index]);
            setState(() {});
            print(todoList.length);
          },
          icon: Icon(Icons.delete),
        ),
      ],
    ),
  );

  AppBar appBar() => AppBar(
    toolbarHeight: 160,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    title: Column(
      children: [
        const Text(
          'To do List App',
          style: TextStyle(
            color: Colors.black,
            fontWeight: .w800,
            fontSize: 36,
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.8,
          height: 60,
          child: TextFormField(
            cursorColor: Colors.black,
            controller: _controller,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            onEditingComplete: () => makeTodoList(_controller.text),
            decoration: InputDecoration(
              contentPadding: .symmetric(horizontal: 10, vertical: 15),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Icon(Icons.chevron_right_outlined),
              ),
              prefixIconColor: Colors.grey,
              prefixIconConstraints: BoxConstraints(minWidth: 30),
              border: .none,
              enabledBorder: OutlineInputBorder(
                borderRadius: .circular(12),
                borderSide: BorderSide(width: 1, color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: .circular(12),
                borderSide: BorderSide(width: 1, color: Colors.black),
              ),
              hintText: 'Please enter your ToDo List',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    ),
  );
}
