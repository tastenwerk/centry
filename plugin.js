'use strict';

var express             = require('express');
var fs                  = require('fs');
var path                = require('path');
var _                   = require('lodash');

var Promise             = require('bluebird');

var join                = path.join;
var basename            = path.basename;
var extname             = path.extname;

var glob                = require('glob');

// var utils               = require(join( __dirname, 'lib/utils' ));
// var getCallerDirname    = utils.getCallerDirname
var logger              = require(join( __dirname, 'logger' ));

var registry = [];

module.exports.register = function(pluginPath){
  var pluginPath = pluginPath; //|| getCallerDirname();
  var pluginName = basename(pluginPath, '.coffee');
  registry.push( { name: pluginName, path: pluginPath });
  logger.info( 'plugin registered: %s', pluginName );
};

/**
 * initialize all models (and run their migration if any)
 */
module.exports.initModelPaths = function( db ){
  var models = [];
  registry.forEach( function(plugin){
    glob
      .sync( join(plugin.path, 'app', 'models') + '**/*.js' )
      .forEach( function(filename){
        models.push( require(filename)(db) );
      });
  });
  return Promise.all( models );
};


/**
 * load all routes without attaching to any route
 */
module.exports.initRoutePaths = function(){
  var routers = {};
  registry.forEach( function(plugin){
    glob
      .sync( join(plugin.path, 'app', 'routes') + '**/*.js' )
      .forEach( function(filename){
        var routeName = basename(filename,extname(filename));
        logger.info('adding router', routeName);
        routers[routeName] = require(filename)( express.Router() );
      });
  });
  return routers;
};