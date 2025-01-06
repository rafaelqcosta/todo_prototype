import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_prototype/core/icons/taski_icons.dart';
import 'package:todo_prototype/core/images/taski_images.dart';
import 'package:todo_prototype/ui/todo_list/widgets/components/add_or_update_todo_bottom_sheet.dart';

import 'data/repositories/todo_repository.dart';
import 'data/services/database_service.dart';
import 'ui/todo_list/viewmodel/todo_list_viewmodel.dart';
import 'ui/todo_list/widgets/todo_list_screen.dart';

void main() {
  late DatabaseService databaseService;
  if (kIsWeb) {
    throw UnsupportedError('Platform not supported');
  } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseService = DatabaseService(
      databaseFactory: databaseFactoryFfi,
    );
  } else {
    databaseService = DatabaseService(
      databaseFactory: databaseFactory,
    );
  }

  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: MainApp(
        todoRepository: TodoRepository(
          database: databaseService,
        ),
      ),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
    required this.todoRepository,
  });

  final TodoRepository todoRepository;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final todoListViewModel = TodoListViewModel(
      todoRepository: TodoRepository(
    database: DatabaseService(databaseFactory: databaseFactory),
  ));
  bool isSearching = false;
  bool isDone = false;
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(width: 16),
          Text('John', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(width: 8),
          CircleAvatar(backgroundImage: const AssetImage(TaskiImages.fakeAvatar)),
          SizedBox(width: 16),
        ],
        title: Row(
          children: [
            Image.asset(TaskiImages.logo),
            const SizedBox(width: 8),
            Expanded(child: Text('Taski')),
          ],
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              isSearching = false;
              isDone = false;
              _currentIndex = index;
            case 1:
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return AddOrUpdateTodoBottomSheet(viewModel: todoListViewModel);
                },
              );
              isSearching = false;
              isDone = false;
              _currentIndex = 1;
              break;
            case 2:
              isSearching = true;
              isDone = false;
              _currentIndex = 2;
              break;
            case 3:
              isSearching = false;
              isDone = true;
              _currentIndex = 3;
          }
          setState(() {});
        },
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              TaskiIcons.todo,
            ),
            activeIcon: SvgPicture.asset(
              TaskiIcons.todo,
              colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
            label: 'Todo',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              TaskiIcons.plus,
            ),
            activeIcon: SvgPicture.asset(
              TaskiIcons.plus,
              colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              TaskiIcons.search,
            ),
            activeIcon: SvgPicture.asset(
              TaskiIcons.search,
              colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              TaskiIcons.checked,
            ),
            activeIcon: SvgPicture.asset(
              TaskiIcons.checked,
              colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
            label: 'Done',
          ),
        ],
      ),
      body: TodoListScreen(viewModel: todoListViewModel, isSearching: isSearching, isDone: isDone),
    );
  }
}
