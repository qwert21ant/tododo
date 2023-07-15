enum Routes { main, edit }

class NavigationState {
  Routes name;
  int? taskIndex;

  NavigationState(this.name, {this.taskIndex});
}
