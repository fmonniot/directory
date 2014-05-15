describe "PeopleController", ->
  [$controller, $rootScope, $scope, $modal, $people, $modalCtrl] = [null]

  beforeEach module('app')

  beforeEach inject ($injector) ->
    $controller = $injector.get('$controller')
    $rootScope  = $injector.get('$rootScope')
    $scope      = $rootScope.$new()
    $modal      = $injector.get('$modal')
    $people     = $injector.get('People')
    $modalCtrl  = $injector.get('ModalCtrlFactory')

    spyOn( $rootScope, '$broadcast')

  beforeEach ->
    $controller('PeopleController', {
      $scope: $scope,
      $modal: $modal,
      People: $people,
      ModalCtrlService: $modalCtrl})

  it "is correctly initialized", ->
    expect($scope.query).toBe('')
    expect($scope.type).toBe('n')

    expect($scope.reload).toBeDefined()
    expect($scope.delete).toBeDefined()

  it "reload correctly", ->
    runs ->
      $scope.reload()

    waits 200

    runs ->
      expect($scope.people).toBeDefined()
      expect($rootScope.$broadcast).toHaveBeenCalledWith('reload-infiniteScroll')

  it "open the delete modal with correct params", ->
    spyOn($modal, 'open')
    $scope.delete($people)

    expect($modal.open).toHaveBeenCalled()

    expect($modal.open.mostRecentCall.args[0].resolve.person()).toEqual($people)