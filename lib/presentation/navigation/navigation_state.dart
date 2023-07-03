enum Routes { main, edit, load }

class NavigationState {
  Routes name;
  int? taskIndex;

  NavigationState(this.name, {this.taskIndex});
}
