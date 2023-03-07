const http = require('http');

const logger = require('./logger');

const server = new http.Server();

server.on('request', (req, res) => {
  const method = req.method;
  const path = req.url;
  const source = req.socket.remoteAddress;

  try {
    logger.info({
      message: `Received ${method} request to ${path} from ${source}`,
      method,
      source,
      path});

    if (path == '/' && method === 'POST' && req.headers.notbad === 'true') {
      res.writeHead(200, {'Content-Type': 'text/plain'});
      res.end('ReallyNotBad');
    } else {
      res.writeHead(404, {'Content-Type': 'text/plain'});
      res.end('Not found');
    }
  } catch (error) {
    logger.error({
      message: `Error processing request: ${error}`,
      method,
      source,
      path});

    res.writeHead(500, {'Content-Type': 'text/plain'});
    res.end('Internal server error');
  }
});


module.exports = server;
