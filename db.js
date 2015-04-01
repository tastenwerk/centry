var Sequelize = require('sequelize');

var path                  = require('path');
var join                  = path.join;
var settings              = require(join(__dirname,'settings'));
var logger                = require(join(__dirname,'logger'));
var plugin                = require(join(__dirname,'plugin'));
var utils                 = require(join(__dirname,'lib', 'utils'));

var dbURI = settings.db.name;
if( dbURI.indexOf('/') !== 0 )
  dbURI = join( process.cwd(), dbURI );

if( settings.db.adapter === 'sqlite' )
  dbURI = 'sqlite://' + dbURI;

var db;

module.exports.start = function(){

  db = new Sequelize( dbURI );
  logger.info('db connection established, using:', settings.db.name);
  plugin
    .initModelPaths( db )
    .then( function(result){
      logger.info('model initialization completed.');
    });
};

module.exports.connection = function(){
  return db;
};
