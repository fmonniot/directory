describe 'Indicator Click', ->
  [$rootScope, $compile, $document, $parse, $deferred] = [null]

  beforeEach ->
    module('app')

  beforeEach ->
    inject (_$rootScope_, _$compile_, _$window_, _$document_, _$parse_, _$q_) ->
      $rootScope = _$rootScope_
      $compile = _$compile_
      $window = _$window_
      $document = _$document_
      $parse = _$parse_
      $deferred = _$q_.defer()

  it 'pass the button as parameters to the callback', ->
    button = """
    <button data-indi-click="send()">Text</button>
    """

    el = angular.element(button)
    $('body').append(el)

    scope = $rootScope.$new(true)

    $deferred.resolve (button) ->
      expect(button).toEqual(el[0])
    scope.send = -> $deferred.promise


    $compile(el)(scope)
    el.click()

    el.remove()
    scope.$destroy()

  it 'only change the button size and add spinner', ->
    button = """
    <button data-indi-click="send()">Text</button>
    """

    el = angular.element(button)
    $('body').append(el)

    scope = $rootScope.$new(true)
    scope.send = -> $deferred.promise

    $compile(el)(scope)
    el.click()
    button = el[0]

    expect(button.disabled).toEqual(true)

    expect(button.innerText).toEqual("Text")

    expect(button.childNodes.length).toEqual(2)
    expect(button.children[0].className).toEqual('spinner')

    el.remove()
    scope.$destroy()

  it 'reset the button after the action is resolved', ->
    button = """
    <button data-indi-click="send()">Text</button>
    """

    el = angular.element(button)
    $('body').append(el)

    scope = $rootScope.$new(true)
    $deferred.resolve (button) ->
      return button
    scope.send = -> $deferred.promise

    $compile(el)(scope)
    el.click()
    button = el[0]

    expect(button.disabled).toEqual(false)

    expect(button.innerText).toEqual("Text")

    expect(button.childNodes.length).toEqual(1)

    el.remove()
    scope.$destroy()

  it 'partialy reset the button after the action is rejected', ->
    button = """
    <button data-indi-click="send()">Text</button>
    """

    el = angular.element(button)
    $('body').append(el)

    scope = $rootScope.$new(true)
    $deferred.reject (button) ->
      return button
    scope.send = -> $deferred.promise

    $compile(el)(scope)
    el.click()
    button = el[0]

    expect(button.disabled).toEqual(true)

    expect(button.innerText).toEqual("Text")

    expect(button.childNodes.length).toEqual(1)

    el.remove()
    scope.$destroy()