'use strict';

var bunyan                = require('bunyan');

module.exports = bunyan.createLogger({
  name: 'centry'
});
