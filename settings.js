var _                     = require('lodash');
var settings              = require(process.cwd()+'/config/env.'+process.env.NODE_ENV);
var defaults = {
  port: 5000
};

module.exports = _.merge( defaults, settings );