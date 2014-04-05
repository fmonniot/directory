class ModalCtrlFactory
  self = null

  constructor: (@http, @q, @apiBaseUrl) ->
    self = this # Fix scope conflict between Angular and CoffeeScript
    @indiClickDeferred = @q.defer();


  success: () ->
    self.scope.success = "An email has been sent to "+@email+".\n
                          Follow instructions in this mail."

    self.indiClickDeferred.resolve (button) ->
      self.scope.send = null # prevent user to resend the mail

      $button = $(button)
      $button.click ->
        self.modal.dismiss "closed"

      $button.removeClass('btn-warning').addClass('btn-info').html('Close')


  error: () ->
    self.scope.error = "A request to modify this person already exist.
                        Valid it before making a new one."

    self.indiClickDeferred.reject (button) ->
      $button = $(button)
      $button.removeClass('btn-primary').addClass('btn-danger')

  create: ($scope, $modalInstance, person) ->
    $scope.person = angular.copy person
    self.scope = $scope
    self.email = person.email
    self.modal = $modalInstance
    
    $scope.send = ->
      self.http.delete(self.apiBaseUrl+"/people/"+person.id)
               .success(self.success).error(self.error)

      self.indiClickDeferred.promise

    $scope.cancel = ->
      $modalInstance.dismiss "cancel"

app.factory "ModalCtrlFactory"
, ['$http', '$q', 'Settings', ($http, $q, settings) ->
  new ModalCtrlFactory $http, $q, settings.apiBaseUri
]