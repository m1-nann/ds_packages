import 'dart:convert';

import 'package:http/http.dart' as http;

enum _Method { get, post, put, delete }

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);
}

class BadRequestException implements Exception {
  final String message;

  BadRequestException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
}

class ForbiddenException implements Exception {
  final String message;

  ForbiddenException(this.message);
}

class ConflictException implements Exception {
  final String message;

  ConflictException(this.message);
}

class UnprocessableEntityException implements Exception {
  final String message;

  UnprocessableEntityException(this.message);
}

class TooManyRequestsException implements Exception {
  final String message;

  TooManyRequestsException(this.message);
}

class InternalServerErrorException implements Exception {
  final String message;

  InternalServerErrorException(this.message);
}

class BadGatewayException implements Exception {
  final String message;

  BadGatewayException(this.message);
}

class ServiceUnavailableException implements Exception {
  final String message;

  ServiceUnavailableException(this.message);
}

class GatewayTimeoutException implements Exception {
  final String message;

  GatewayTimeoutException(this.message);
}

abstract class JsonClient {
  Uri get baseUri;

  Map<String, String> get headers;

  /// Parse error and Throw custom exception here
  void Function(http.Response)? get interceptor;

  Future<dynamic> GET(
    String path, {
    List<String>? queries,
  }) async {
    return _method(_Method.get, path, queries: queries);
  }

  Future<dynamic> POST(
    String path, {
    List<String>? queries,
    dynamic data,
  }) async {
    return _method(_Method.post, path, queries: queries, data: data);
  }

  Future<dynamic> PUT(
    String path, {
    List<String>? queries,
    dynamic data,
  }) async {
    return _method(_Method.put, path, queries: queries, data: data);
  }

  Future<dynamic> DELETE(
    String path, {
    List<String>? queries,
  }) async {
    return _method(_Method.delete, path, queries: queries);
  }

  Future<dynamic> _method(
    _Method method,
    String path, {
    List<String>? queries,
    dynamic data,
  }) async {
    final uri = baseUri.replace(
      path: [baseUri.path, path].join(''),
      query: queries?.join('&'),
    );
    late final http.Response response;

    switch (method) {
      case _Method.get:
        response = await http.get(uri);
        break;
      case _Method.post:
        response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json', ...headers},
          body: jsonEncode(data),
        );
        break;
      case _Method.put:
        response = await http.put(
          uri,
          headers: {'Content-Type': 'application/json', ...headers},
          body: jsonEncode(data),
        );
        break;
      case _Method.delete:
        response = await http.delete(uri);
        break;
    }

    if (interceptor != null) {
      interceptor!(response);
    }

    if (response.statusCode == 400) {
      throw BadRequestException(
          "Request [${uri.toString()}] failed with status 400: ${response.body}");
    }

    if (response.statusCode == 401) {
      throw UnauthorizedException(
          "Request [${uri.toString()}] failed with status 401: ${response.body}");
    }

    if (response.statusCode == 403) {
      throw ForbiddenException(
          "Request [${uri.toString()}] failed with status 403: ${response.body}");
    }

    if (response.statusCode == 404) {
      throw NotFoundException(
          "Request [${uri.toString()}] failed with status 404: ${response.body}");
    }

    if (response.statusCode == 409) {
      throw ConflictException(
          "Request [${uri.toString()}] failed with status 409: ${response.body}");
    }

    if (response.statusCode == 422) {
      throw UnprocessableEntityException(
          "Request [${uri.toString()}] failed with status 422: ${response.body}");
    }

    if (response.statusCode == 429) {
      throw TooManyRequestsException(
          "Request [${uri.toString()}] failed with status 429: ${response.body}");
    }

    if (response.statusCode == 500) {
      throw InternalServerErrorException(
          "Request [${uri.toString()}] failed with status 500: ${response.body}");
    }

    if (response.statusCode == 502) {
      throw BadGatewayException(
          "Request [${uri.toString()}] failed with status 502: ${response.body}");
    }

    if (response.statusCode == 503) {
      throw ServiceUnavailableException(
          "Request [${uri.toString()}] failed with status 503: ${response.body}");
    }

    if (response.statusCode == 504) {
      throw GatewayTimeoutException(
          "Request [${uri.toString()}] failed with status 504: ${response.body}");
    }

    if (response.statusCode >= 400) {
      throw Exception(
          "Request [${uri.toString()}] failed with status ${response.statusCode}: ${response.body}");
    }

    return jsonDecode(response.body);
  }
}
