import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/retry.dart';

import 'package:tododo/model/task.dart';

class NetException implements Exception {
  int statusCode;
  String? message;

  NetException(this.statusCode, [this.message]);

  @override
  String toString() {
    if (message != null) {
      return 'NetException [$statusCode]: $message';
    }

    if (statusCode == 400) return 'NetException [400]: Bad request';
    if (statusCode == 401) return 'NetException [401]: Unauthorized';
    if (statusCode == 500) return 'NetException [500]: Server error';

    return 'NetException [$statusCode]';
  }
}

typedef JsonObject = Map<String, dynamic>;

abstract final class NetMan {
  static const baseUrl = 'https://beta.mrdekk.ru/todobackend';
  static const _token = '*some token*';

  static int? _revision;
  static int? failsThreshold;

  static final _client = RetryClient(
    Client(),
    when: (BaseResponse response) => response.statusCode == 500,
  );

  static JsonObject _handleResponse(Response response) {
    if (response.statusCode == 200) {
      final JsonObject body = jsonDecode(response.body);

      if (body['status'] != 'ok') {
        throw NetException(200, 'Unknown status: ${body['status']}');
      }

      _revision = body['revision'];

      return body;
    }

    throw NetException(response.statusCode);
  }

  static Future<JsonObject> _send(
    String method,
    String path, [
    JsonObject? body,
  ]) {
    final request = Request(method, Uri.parse('$baseUrl/$path'));

    // Headers
    request.headers['Authorization'] = 'Bearer $_token';
    if (_revision != null) {
      request.headers['X-Last-Known-Revision'] = _revision!.toString();
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
    return _client
        .send(request)
        .then(Response.fromStream)
        .then(_handleResponse);
  }

  static Future<List<TaskData>> getTasks() => _send(
        'GET',
        'list',
      ).then((JsonObject object) {
        final List<dynamic> list = object['list'];

        return Future.value(
          list.map((item) => TaskData.fromJson(item)).toList(),
        );
      });

  static Future<void> setTasks(List<TaskData> tasks) => _send(
        'PATCH',
        'list',
        {'list': tasks.map((item) => item.toJson()).toList()},
      );

  static Future<TaskData> getTask(String id) => _send(
        'GET',
        'list/$id',
      ).then((JsonObject object) {
        final element = object['element'];

        return Future.value(TaskData.fromJson(element));
      });

  static Future<void> addTask(TaskData task) => _send(
        'POST',
        'list',
        {'element': task.toJson()},
      );

  static Future<void> updateTask(TaskData task) => _send(
        'PUT',
        'list/${task.id}',
        {'element': task.toJson()},
      );

  static Future<void> deleteTask(String id) => _send(
        'DELETE',
        'list/$id',
      );
}
