describe "ModalCtrlFactory", ->
  [$http, $q, $rootScope, $scope, $person, $modalImpl, $modalCtrl, controller] = [null]
  apiBaseUrl = '/api/v1/people/'

  beforeEach module('app')

  beforeEach inject ($injector) ->
    $http       = $injector.get('$httpBackend')
    $q          = $injector.get('$q')
    $rootScope  = $injector.get('$rootScope')
    $scope      = $rootScope.$new()
    $modalCtrl  = $injector.get('ModalCtrlFactory')

    $modalImpl  = { dismiss: ((signal) -> signal) }
    $person     = { id: 'some_id', first_name: 'William', last_name: 'Dalton'}
    

  beforeEach ->
    controller = $modalCtrl.create $scope, $modalImpl, $person

  it "is correctly initialized", ->
    expect($scope.person).toEqual $person
    expect($scope.send).toBeDefined()
    expect($scope.cancel).toBeDefined()

  it "dismiss the modal", ->
    spyOn($modalImpl, 'dismiss')
    $scope.cancel()

    expect($modalImpl.dismiss).toHaveBeenCalled()

  describe "when the server receive a good request", ->
    beforeEach ->
      $http.when('DELETE',apiBaseUrl+$person.id).respond({person: $person})

    it "call the API when send() is invoked", ->
      $scope.send()

      $http.flush()
      $scope.$digest()

      $http.expectDELETE(apiBaseUrl+$person.id).respond(200, '')

    it "update correctly the view", ->
      promise = $scope.send()
      expect(promise).not.toBeNull()

      button = document.createElement('button')
      promise.then ((fct) -> fct(button))

      $http.flush()
      $scope.$digest()

      expect($scope.success).toBeDefined()
      expect($scope.success).toContain($person.email)
      expect($scope.error).not.toBeDefined()
      expect($scope.send).toBeNull()
      expect(button.disabled).toBe(false)
      expect(button.className).toContain('btn-info')
      expect(button.innerHTML).toBe('Close')

    it "close the modal after clicked on send", ->
      promise = $scope.send()
      expect(promise).not.toBeNull()

      button = document.createElement('button')
      promise.then ((fct) -> fct(button))

      $http.flush()
      $scope.$digest()

      spyOn($modalImpl, 'dismiss')
      button.click()
      
      expect($modalImpl.dismiss).toHaveBeenCalled()

  describe "when the server receive a bad request", ->  

    it "update correctly the view", ->
      $http.when('DELETE',apiBaseUrl+$person.id).respond(404)
      promise = $scope.send()
      expect(promise).not.toBeNull()

      button = document.createElement('button')
      promise.then (-> ), ((fct) -> fct(button))

      $http.flush()
      $scope.$digest()
      $http.expectDELETE(apiBaseUrl+$person.id).respond(404, 'bad ID')

      expect($scope.success).not.toBeDefined()
      expect($scope.error).toBeDefined()
      expect(button.disabled).toBe(false)
      expect(button.className).toContain('btn-danger')