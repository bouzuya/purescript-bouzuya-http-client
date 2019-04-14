"use strict";

exports.fetchImpl = function (options) {
  return function () {
    var http = require('http');
    var https = require('https');
    var url = require('url');
    return new Promise(function (resolve, reject) {
      var urlObj = url.parse(options.url);
      var request = (urlObj.protocol === 'https:' ? https : http).request({
        family: urlObj.family,
        headers: options.headers,
        host: urlObj.host,
        method: options.method,
        path: urlObj.path,
        port: urlObj.port,
        protocol: urlObj.protocol,
      }, function (response) {
        // TODO: http.IncomingMessage Event 'aborted'
        // TODO: http.IncomingMessage Event 'close'
        var body = [];
        response.setEncoding('utf8'); // TODO: support Buffer
        // TODO: stream.Readable Event 'close'
        response.on('data', function (chunk) {
          body += chunk;
        });
        response.on('end', function () {
          resolve({
            body: body,
            headers: response.headers,
            statusCode: response.statusCode
          });
        });
        response.on('error', function (error) {
          reject(error);
        });
        // ignore stream.Readable Event 'readable'
      });
      // TODO: Event 'abort'
      // TODO: Event 'connect'
      // TODO: Event 'continue' 100
      // TODO: Event 'information' 1xx
      // Event 'response' See: callback
      // TODO: Event 'socket'
      // TODO: Event 'timeout'
      // TODO: Event 'upgrade'
      // TODO: stream.Writable Event 'close'
      // TODO: stream.Writable Event 'drain'
      request.on('error', function (error) {
        reject(error);
      });
      // TODO: stream.Writable Event 'finish'
      // ignore stream.Writable Event 'pipe'
      // ignore stream.Writable Event 'unpipe'
      if (typeof options.body !== 'undefined') {
        request.write(options.body);
      }
      request.end();
    });
  };
};

exports.headersImpl = function (response) {
  return response.headers;
};

exports.textImpl = function (response) {
  return typeof response.body !== 'string'
    ? JSON.stringify(response.body)
    : response.body;
};

exports.statusImpl = function (response) {
  return response.statusCode;
};
