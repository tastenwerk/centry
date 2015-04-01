'use strict';

/**
 * default node environment is
 * "development"
 */
process.env.NODE_ENV = process.env.NODE_ENV || 'development';

var fs                    = require('fs');
var path                  = require('path');
var join                  = path.join;

var express               = require('express');
var settings              = require(join(__dirname,'settings'));
// var session               = require('express-session');
// var FileStore             = require('session-file-store')(session);
var bodyParser            = require('body-parser');
// var moment                = require('moment');
// var lodash                = require('lodash');
var assets                = require('connect-assets');


var logger                = require(join(__dirname,'logger'));
var plugin                = require(join(__dirname,'plugin'));
var db                    = require(join(__dirname,'db'));

var app = express();

// app.use(session, {
//   store: new FileStore(),
//   secret: '6sjAPF7DnqmcIus_H7JHCg',
//   resave: false,
//   saveUninitialized: false
// });

app.use( express.static( join(process.cwd(), 'public') ) );

app.use( bodyParser.urlencoded({ extended: true }) );

module.exports.app = app;

module.exports.start = function(){
  var routers = plugin.initRoutePaths();
  require(join( process.cwd(), 'config', 'routes' ))( app, routers );
  db.start();
  var server = app.listen( settings.port, function(){
    var host = server.address().address;
    var port = server.address().port;
    logger.info( 'centry started in %s mode', process.env.NODE_ENV.toUpperCase() );
    logger.info( 'listening at http://%s:%s', host, port );
  });
};
