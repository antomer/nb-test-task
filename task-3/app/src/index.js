const server = require('./server');
const logger = require('./logger');

const port = process.env.PORT || 8089;

server.listen(port, () => {
  logger.info({message: `Server is listening on port ${port}`});
});
