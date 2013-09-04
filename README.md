service-registry
================

A simple registry to associated versioned service names with host/ip info

## Installation

npm install service-registry

## Example

> See test/registry.spec.coffee for all usage examples

### Registering a service

    var Registry = require('service-registry');
    var r = new Registry();

    r.register('hello-service@1.0.2', '127.0.0.1', 80, { additionalExampleField: 'world'});

### Getting a service

    var info = r.get('hello-service@1.x');

`info` then contains:

    {
      "name": "hello-service",
      "fullName": "hello-service@1.0.2",
      "version": "1.0.2",
      "host": "127.0.0.1",
      "port": 80,
      "meta": {
        "additionalExampleField": "world"
      }
    }

> Note: You must use the same `Registry` instance

### Listing all services

    var services = r.services();

`services` then contains an array of info instances as above

### Unregistering a service

    r.unregister('hello-service@1.0.2');

## Tests

    npm test

## Development

When developing install all packages after cloning (`npm i`) and then run `npm run-script dev`.

The dev script runs `nodemon test.js` (if **nodemon** is not installed, just install it with `npm i -g nodemon`) and also connects to **growl*** to notify the developer about any errors during development (this is done via [cura-test-runner](https://npmjs.org/package/cura-test-runner)