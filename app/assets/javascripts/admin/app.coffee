# Create 'app' angular application (module)
@app = angular.module("admin", ['ui.bootstrap'])

@app.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest';
]);