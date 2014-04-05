# Create 'app' angular application (module)
@app = angular.module("app", ['ui.bootstrap'])

@app.config(['$httpProvider', ($httpProvider) ->
    $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest';
]);

@app.constant('Settings', {
    apiBaseUri: '/api/v1'
});