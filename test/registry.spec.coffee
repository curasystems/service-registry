Registry = require('..')

describe 'registry', ->

  VALID_SERVICE_NAME = 'test@1.0.0'
  TEST_HOST = '127.0.0.1'
  TEST_PORT = 2345

  r = null

  beforeEach ()->
    r = new Registry()

  it 'can register a service', ->
    r.register(VALID_SERVICE_NAME, TEST_HOST, TEST_PORT)
  
  describe 'with a registered service', ->
  
    beforeEach ()->
      r.register(VALID_SERVICE_NAME, TEST_HOST, TEST_PORT) 

    it 'can list all registered services', ()->
      r.services().should.be.instanceof(Array)
      r.services().length.should.equal(1)

    it 'can get matching service info using the same service name as when registering', ->

      info = r.get(VALID_SERVICE_NAME)

      info.host.should.equal(TEST_HOST)
      info.port.should.equal(TEST_PORT)

    it 'can get a matching service using a semver query matching the registered service', ->

      MATCHING_SERVICE_VERSION_QUERY = 'test@1.x'

      info = r.get(MATCHING_SERVICE_VERSION_QUERY)

      info.host.should.equal(TEST_HOST)
      info.port.should.equal(TEST_PORT)

    it 'returns null when no matching service is found ', ->

      VERSION_QUERY = 'test@2.x'

      isNull = r.get(VERSION_QUERY) is null
      isNull.should.be.true

    describe 'the first service returned from the listing', ->
          
      info = null

      beforeEach ->
        info = r.services()[0]

      it 'includes the full service name used on registration', ->
        info.fullName.should.equal(VALID_SERVICE_NAME)

      it 'includes the host and port', ->
        info.host.should.equal(TEST_HOST)
        info.port.should.equal(TEST_PORT)

      it 'includes the name but without the version', ->
        info = r.services()[0]
        info.name.should.equal('test')
        
      it 'includes the version', ->
        info = r.services()[0]
        info.version.should.equal('1.0.0')

    describe 'un-registering a service', ->
        
      beforeEach ->
        # this is how you might do it, or write r.unregister(VALID_SERVICE_NAME) in this case
        info = r.get(VALID_SERVICE_NAME)
        r.unregister(info.fullName)

      it 'unregistered services are not listed any more', ->
        r.services().length.should.equal(0)
    
      it 'unregistered services are not listed any more', ->
        isNull = r.get(VALID_SERVICE_NAME) is null
        isNull.should.be.true
    
  describe 'meta-data', ->

    META_DATA = { test: 1 }

    beforeEach ->        
      r.register(VALID_SERVICE_NAME, TEST_HOST, TEST_PORT, META_DATA)

    it 'returns the meta-data when getting the service', ->
      info = r.get(VALID_SERVICE_NAME)
      info.meta.should.equal(META_DATA)
