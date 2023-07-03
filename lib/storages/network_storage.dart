import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/retry.dart';

import 'package:tododo/model/task.dart';
import 'package:tododo/utils/logger.dart';

import 'storage.dart';

class NetException implements Exception {
  int statusCode;
  String? message;

  NetException(this.statusCode, [this.message]);

  bool get isUnsync => statusCode == 400;

  @override
  String toString() {
    if (message != null) {
      return 'NetException [$statusCode]: $message';
    }

    if (statusCode == 400) return 'NetException [400]: Bad request';
    if (statusCode == 401) return 'NetException [401]: Unauthorized';
    if (statusCode == 404) return 'NetException [404]: Not found';
    if (statusCode == 500) return 'NetException [500]: Server error';

    return 'NetException [$statusCode]';
  }
}

typedef JsonObject = Map<String, dynamic>;

final class NetStorage implements Storage {
  static const baseUrl = 'https://beta.mrdekk.ru/todobackend';
  static const _token = '*some token*';

  static int? failsThreshold;

  NetStorage();

  int _revision = -1;

  @override
  int get revision => _revision;

  final _client = RetryClient(
    Client(),
    when: (BaseResponse response) => response.statusCode == 500,
  );

  JsonObject _handleResponse(Response response) {
    if (response.statusCode == 200) {
      final JsonObject body = jsonDecode(response.body);

      if (body['status'] != 'ok') {
        throw NetException(200, 'Unknown status: ${body['status']}');
      }

      _revision = body['revision'];

      return body;
    }

    final e = NetException(response.statusCode);
    Logger.warn(e.toString(), 'network');
    throw e;
  }

  Future<JsonObject> _send(
    String method,
    String path, [
    JsonObject? body,
  ]) async {
    // return Future.delayed(const Duration(milliseconds: 2000), () => Future.error('bababa'));

    final request = Request(method, Uri.parse('$baseUrl/$path'));

    // Headers
    request.headers['Authorization'] = 'Bearer $_token';
    if (_revision != -1) {
      request.headers['X-Last-Known-Revision'] = _revision.toString();
    }
    if (failsThreshold != null) {
      request.headers['X-Generate-Fails'] = failsThreshold!.toString();
    }

    // Body
    if (body != null) {
      request.body = jsonEncode(body);
      request.headers['Content-Type'] = 'application/json';
    }

    // Send
    final response = await Response.fromStream(await _client.send(request));
    return _handleResponse(response);
  }

  @override
  Future<List<TaskData>> getTasks() async {
    final data = await _send('GET', 'list');
    final List<dynamic> list = data['list'];

    return Future.value(
      list.map<TaskData>((item) => TaskData.fromJson(item)).toList(),
    );
  }

  @override
  Future<void> setTasks(List<TaskData> tasks) async {
    await _send('PATCH', 'list', {
      'list': tasks.map((item) => item.toJson()).toList(),
    });
  }

  @override
  Future<TaskData> getTask(String id) async {
    final data = await _send('GET', 'list/$id');
    final element = data['element'];

    return Future.value(TaskData.fromJson(element));
  }

  @override
  Future<void> addTask(TaskData task) async {
    await _send('POST', 'list', {'element': task.toJson()});
  }

  @override
  Future<void> updateTask(TaskData task) async {
    await _send('PUT', 'list/${task.id}', {'element': task.toJson()});
  }

  @override
  Future<void> deleteTask(String id) async {
    await _send('DELETE', 'list/$id');
  }
}
