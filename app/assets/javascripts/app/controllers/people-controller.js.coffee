app.controller "PeopleController"
, ['$scope','$modal','People', 'ModalCtrlFactory'
, ($scope, $modal, People, ModalCtrlFactory) ->

  $scope.query = ''
  $scope.type = 'n'
  _modal_controller = ModalCtrlFactory.create

  $scope.reload = ->
    window.clearTimeout(@pendingRequest) if (@pendingRequest)
    
    #console.log Date() + '| SETTING request to take place with query '+$scope.query

    @pendingRequest = window.setTimeout( ->
      #console.log Date() + '| DOING   request with query ', $scope.query

      $scope.people = new People($scope.query, $scope.type)
      $scope.$broadcast('reload-infiniteScroll')
    , 200)


  $scope.delete = (person) ->
    modalInstance = $modal.open
      templateUrl: "templates/delete.html"
      controller: _modal_controller
      backdrop: true
      resolve:
        person: -> person
]