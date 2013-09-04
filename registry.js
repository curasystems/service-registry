'use strict';

var semver = require('semver');

module.exports = Registry;

function Registry(){
  this._services = {};
}

Registry.prototype.register = function(serviceName,host,port,meta) {

  var nameParts = serviceName.split('@',2);
  var name = nameParts[0];
  var version = nameParts[1] || '0.0.0';

  this._services[serviceName] = {
    fullName: serviceName,
    name: name,
    version: version,
    host: host,
    port: port,
    meta: meta
  };

};

Registry.prototype.services = function(){

  var infos = [];

  for( var serviceName in this._services ){

    var info = this._cloneInfo( this._services[serviceName] );
    infos.push(info);

  }

  return infos;
};

Registry.prototype._cloneInfo = function(info){
  
  if(!info)
    return info;

  var clone = {
      fullName: info.fullName,
      name: info.name,
      version: info.version,
      host: info.host,
      port: info.port,
      meta: info.meta
    };
  return clone;
};

Registry.prototype.get = function(name) {

  var match = this._services[name] || this._findMatch(name);

  return this._cloneInfo( match );
};

Registry.prototype._findMatch = function(serviceName) {
  
  var nameParts = serviceName.split('@',2);
  var name = nameParts[0];
  var requestedVersionRange = nameParts[1] || '>=0.0.0';

  var service = null;

  this.services().forEach(function(info){
    if(info.name.toLowerCase() === name.toLowerCase() ){
      if(semver.satisfies(info.version, requestedVersionRange)){
        service = info;
      }
    }
  });

  return service;
};

Registry.prototype.unregister = function(serviceName) {
  delete this._services[serviceName];
};