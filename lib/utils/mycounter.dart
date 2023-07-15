class CounterWithListener {
  int _counter;
  void Function(int)? _listener;

  CounterWithListener({
    int initValue = 0,
    void Function(int)? listener,
  })  : _counter = initValue,
        _listener = listener;

  int get value => _counter;

  set value(int newValue) {
    _counter = newValue;
    if (_listener != null) _listener!(_counter);
  }

  set listener(void Function(int) newListener) {
    _listener = newListener;
  }

  void inc() {
    _counter++;
    if (_listener != null) _listener!(_counter);
  }

  void dec() {
    _counter--;
    if (_listener != null) _listener!(_counter);
  }
}
