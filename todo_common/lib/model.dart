@JS("TodoDDC")
library model;

import 'package:polymer_element/polymer_element.dart';
import 'package:js/js.dart';
import 'package:polymer_element/polymerize_js.dart';
import 'package:polymer_element/redux_local.dart';
import 'package:polymer_element/dart_callbacks_behavior.dart';

int _id = 0;

class TodoDTO {
  int id = _id++;
  bool status;
  String text;

  TodoDTO({this.status: false, this.text});
}

class ModelDTO {
  List<TodoDTO> todos = [];
}

ModelDTO model = new ModelDTO();

ModelDTO getModel() => model;

/**
 * The reducer
 */
myReducer(MyState state, ReduxAction action) =>
    new MyState(todos: _reduceTodos(state?.todos, action));

/**
 * Todo list reducer
 */
List<TodoDTO> _reduceTodos(List<TodoDTO> todos, ReduxAction action) {
  switch (action.type) {
    case Actions.ADD_TODO:
      return new List()
        ..addAll(todos ?? [])
        ..add((action as ReduxAction<TodoDTO>).detail);
    case Actions.REMOVE_TODO:
      return new List()
        ..addAll(todos ?? [])
        ..removeAt((action as ReduxAction<int>).detail);
    case Actions.UPDATE_TODO:
      return new List()
          ..addAll(todos??[])
          ..replaceRange(action.detail[1], action.detail[1]+1, [action.detail[0]]);
    default:
      return todos;
  }
}


/**
 * My generic state
 */
class MyState {
  /// a list of todos
  List<TodoDTO> todos;

  MyState({this.todos: const []});
}

final globalStore = createStore(myReducer);

/**
 * Redux behavior associated to store `myStore`.
 * Implemented with a canonical behavior.
 */
@PolymerBehavior("MyReduxBehavior")
abstract class MyReduxBehavior implements ReduxLocalBehavior, DartCallbacksBehavior {
  readyPostHook() {
    store = globalStore;
  }
}

/**
 * Utility class with action factories.
 */
class Actions {
  static const String ADD_TODO = 'ADD_TODO';
  static const String REMOVE_TODO = 'REMOVE_TODO';
  static const String UPDATE_TODO = 'UPDATE_TODO';

  /**
   * Adds a todo to the list.
   */
  static ReduxAction<TodoDTO> createAddTodoAction(TodoDTO todo) =>
      new ReduxAction(type: ADD_TODO, detail: todo);

  static ReduxAction createUpdateTodoAction(TodoDTO todo,int at) =>
    new ReduxAction(type:UPDATE_TODO,detail:<dynamic>[todo,at]);
  /**
   * Removes a todo from the list
   */
  static ReduxAction<int> createRemoveTodoAction(int index) =>
      new ReduxAction<int>(type: REMOVE_TODO, detail: index);
}
