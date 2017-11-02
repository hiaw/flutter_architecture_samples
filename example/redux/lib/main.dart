import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/containers/add_todo.dart';
import 'package:redux_sample/data/todos_service.dart';
import 'package:redux_sample/localization.dart';
import 'package:redux_sample/models.dart';
import 'package:redux_sample/reducers.dart';
import 'package:redux_sample/storeTodosMiddleware.dart';
import 'package:redux_sample/widgets/home_screen.dart';
import 'package:redux_future/redux_future.dart';

void main() {
  runApp(new ReduxApp());
}

class ReduxApp extends StatelessWidget {
  final service;
  final store;

  factory ReduxApp() {
    final service = const TodosService();
    final store = new Store<AppState>(
      stateReducer,
      initialState: new AppState.loading(),
      middleware: [
        futureMiddleware,
        createStoreTodosMiddleware(service),
      ],
    );

    return new ReduxApp._(store, service);
  }

  ReduxApp._(this.store, this.service);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        title: new ReduxLocalizations().appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          new ArchSampleLocalizationsDelegate(),
          new ReduxLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) {
            return new StoreBuilder<AppState>(
              onInit: (store) => store.dispatch(service.loadTodos()),
              builder: (context, store) {
                return new HomeScreen();
              },
            );
          },
          ArchSampleRoutes.addTodo: (context) {
            return new AddTodo();
          },
        },
      ),
    );
  }
}