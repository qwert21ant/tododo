mixin InitializableMock {
  bool isInit = false;
  late bool throwOnInit;

  Future<void> init() async {
    isInit = true;

    if (throwOnInit) throw Exception('Some init error');
  }
}
