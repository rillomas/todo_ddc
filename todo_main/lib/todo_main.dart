import 'dart:async';
import 'package:html5/html.dart';
import 'package:polymer_element/dart_callbacks_behavior.dart';
import 'package:polymer_element/redux_local.dart';
import 'package:polymer_elements/iron_flex_layout.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_element/polymer_element.dart';
import 'package:todo_common/model.dart';
import 'package:polymer_element/observe.dart' as observe;
import 'package:todo_renderer/todo_renderer.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/iron_validatable_behavior.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:polymer_element/super.dart';
import 'package:polymer_elements/iron_meta.dart';

@PolymerBehavior("Sample.MyBehavior")
abstract class MyBehavior implements DartCallbacksBehavior {
  String myProp;

  // TODO : THIS STILL NOT WORKING
  @Observe('myProp')
  void checkObserveOnBehavior(_) {
    print("My Prop has changed in a behavior :${myProp}");
  }

  void readyPostHook() {
    myProp = 'Hello from a behavior';
  }

  doSomething(Event ev, detail) {
    myProp = 'And now has changed';
  }
}

@PolymerRegister('test-comp')
abstract class MyTestComp extends PolymerElement implements MyBehavior {
  static String get template => """
<style>
 :host {
    display: block;
 }

 h2 {
   color:red;
 }
</style>
<div on-click='doSomething'>
  <h2 >Hello, man! Embedded template here! </h2>
  <div>This value comes from a dart behavior (click to changeit):  <b> [[myProp]]</b></div>
  </div>
""";
}

class ClosureEventListener implements EventListener {
  Function handler;
  ClosureEventListener(this.handler);

  void handleEvent(Event ev) => handler(ev);
}

/**
 * A sample main
 */

@PolymerRegister('todo-main', template: 'todo_main.html', uses: const [PaperInput, PaperIconButton, IronFlexLayout, IronIcons, IronIcon, PaperButton, TodoRenderer])
abstract class TodoMain extends PolymerElement implements MyReduxBehavior, MutableData, IronValidatableBehavior {
  String newText;
  @Property(statePath: 'todos')
  List<TodoDTO> todos = [];

  bool canAdd;

  @Observe('newText')
  void checkLen(_) {
    set('canAdd', newText != null && newText.isNotEmpty);
    print("New  text changed, can add : ${canAdd}");
  }

  TodoMain() {
    addEventListener('todo-changed', new ClosureEventListener((Event evt) {
      print("A todo changed (LISTENER):${evt}");
      dispatch(todoChanged((evt as CustomEvent).detail['new'], rpt.indexForElement(evt.target)));
    }));
  }

  aTodoChanged(CustomEvent ev) {
    int pos = rpt.indexForElement(ev.target);
    print("TODO CHANGED  :${pos} , ${ev.detail}");
    dispatch(todoChanged(ev.detail['new'], pos));
  }

  connectedCallback() {
    super.connectedCallback();
    newText = "";
  }

/*
  connectedCallback() {
    newText="_";
    super.connectedCallback();
    () async {
      await new Future.delayed(new Duration(seconds: 0));
      newText="";
      print("Need to understand this better.");
    }();

  }
*/

  @reduxActionFactory
  static ReduxAction todoChanged(TodoDTO newtodo, int at) => Actions.createUpdateTodoAction(newtodo, at);

  @reduxActionFactory
  static ReduxAction<TodoDTO> addTodoAction(TodoDTO newTodo) => Actions.createAddTodoAction(newTodo);

  @reduxActionFactory
  static ReduxAction<int> removeTodoAction(int index) => Actions.createRemoveTodoAction(index);

  addTodo(Event ev, details) async {
    dispatch(addTodoAction(new TodoDTO(text: newText)));
    newText = "";
  }

  DomRepeat get rpt => shadowRoot.querySelector("#rpt");

  void removeIt(Event ev, TodoDTO todo) {
    int idx = rpt.indexForElement(ev.target);
    dispatch(removeTodoAction(idx));
  }
}
