const {createLogger, transports, format} = require('winston');
const logsEnabled = process.env.LOGS_ENABLED || 'true';
const silentLogs = logsEnabled == 'false' ? true : false;

const logger = createLogger({
  level: 'info',
  silent: silentLogs,
  format: format.combine(
      format.timestamp(),
      format.json(),
      // allow structured logging with custom fields
      format((logData) => {
        const {timestamp, level, message, ...args} = logData;
        return {
          ...args,
          level,
          message,
          timestamp,
        };
      })(),
  ),
  transports: [
    new transports.Console(),
  ],
});

module.exports = logger;
