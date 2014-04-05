describe "People", ->
  [$http, $rootScope, $scope, People] = [null]
  apiBaseUrl = '/api/v1/people/'

  beforeEach module('app')

  beforeEach inject ($injector) ->
    $http       = $injector.get('$httpBackend')
    $rootScope  = $injector.get('$rootScope')
    $scope      = $rootScope.$new()
    People      = $injector.get('People')

  it "is correctly initialized", ->
    person = new People("William", "n")

    expect(person.query).toEqual("William")
    expect(person.type).toEqual("n")
    expect(person.items.length).toEqual(0)
    expect(person.pending).toEqual(false)
    expect(person.no_more_result).toEqual(false)

  it "call the correct URL", ->
    $http.when('GET',apiBaseUrl+'search?q=William&type=n&page=1')
         .respond({people: []})

    person = new People("William", "n")
    person.loadMore()
    $http.flush()

    $http.expectGET(apiBaseUrl+'search?q=William&type=n&page=1')
         .respond(200, {})

  it "indicate there is already a pending request", ->
    person = new People("William", "n")
    person.loadMore()

    expect(person.pending).toEqual(true)

  it "do not load more when there is a pending request", ->
    person = new People("William", "n")
    person.loadMore()

    person.loadMore()
    $http.verifyNoOutstandingRequest()

  describe "when there is no more results", ->

    beforeEach ->
      $http.when('GET',apiBaseUrl+'search?q=William&type=n&page=1')
           .respond({people: []})

    it "indicate it", ->
      person = new People("William", "n")
      person.loadMore()
      $http.flush()

      expect(person.no_more_result).toEqual(true)

    it "do not load more", ->
      person = new People("William", "n")
      person.loadMore()
      $http.flush()

      person.loadMore()
      $http.verifyNoOutstandingRequest()

  describe "when there is more to load", ->

    beforeEach ->
      $http.when('GET',apiBaseUrl+'search?q=William&type=n&page=1')
           .respond({people: [{},{}]})
      $http.when('GET',apiBaseUrl+'search?q=William&type=n&page=2')
           .respond({people: [{},{}]})

    it "affects results", ->
      person = new People("William", "n")
      person.loadMore()
      $http.flush()

      expect(person.items.length).toEqual(2)

    it "load more if needed", ->
      person = new People("William", "n")
      person.loadMore()
      $http.flush()
      person.loadMore()
      $http.flush()

      expect(person.items.length).toEqual(4)
      $http.expectGET(apiBaseUrl+'search?q=William&type=n&page=1')
      $http.expectGET(apiBaseUrl+'search?q=William&type=n&page=2')
