# Fork of ngInfiniteScroll by BinaryMuse
# Source available at https://github.com/BinaryMuse/ngInfiniteScroll
# Licensed under the MIT license

describe 'Infinite Scroll', ->
  [$rootScope, $compile, docWindow, $document, $timeout, fakeWindow, origJq] = [undefined]

  beforeEach ->
    module('app')

  beforeEach ->
    inject (_$rootScope_, _$compile_, _$window_, _$document_, _$timeout_) ->
      $rootScope = _$rootScope_
      $compile = _$compile_
      $window = _$window_
      $document = _$document_
      $timeout = _$timeout_
      fakeWindow = angular.element($window)

      origJq = angular.element
      angular.element = (first, args...) ->
        if first == $window
          fakeWindow
        else
          origJq(first, args...)

    spyOn(fakeWindow, 'height').andReturn(1000)

  afterEach ->
    angular.element = origJq

  it 'triggers on scrolling', ->
    scroller = """
    <div infinite-scroll='scroll()' style='height: 1000px'
      infinite-scroll-immediate-check='false'></div>
    """
    el = angular.element(scroller)
    $('body').append(el)

    scope = $rootScope.$new(true)
    scope.scroll = jasmine.createSpy('scroll')
    
    $compile(el)(scope)
    $timeout.flush() # 'immediate' call is with $timeout ..., 0
    fakeWindow.scroll()
    expect(scope.scroll.callCount).toEqual(1)

    el.remove()
    scope.$destroy()

  it 'triggers immediately by default', ->
    scroller = """
    <div infinite-scroll='scroll()' style='height: 1000px'></div>
    """
    el = angular.element(scroller)
    $('body').append(el)

    scope = $rootScope.$new(true)
    scope.scroll = jasmine.createSpy('scroll')
    $compile(el)(scope)
    $timeout.flush() # 'immediate' call is with $timeout ..., 0
    expect(scope.scroll.callCount).toEqual(1)

    el.remove()
    scope.$destroy()

  it 'does not trigger immediately when infinite-scroll-immediate-check is false', ->
    scroller = """
    <div infinite-scroll='scroll()' infinite-scroll-distance='1'
      infinite-scroll-immediate-check='false' style='height: 500px;'></div>
    """
    el = angular.element(scroller)
    $('body').append(el)

    scope = $rootScope.$new(true)
    scope.scroll = jasmine.createSpy('scroll')
    $compile(el)(scope)
    $timeout.flush() # 'immediate' call is with $timeout ..., 0
    expect(scope.scroll).not.toHaveBeenCalled()

    fakeWindow.scroll()
    expect(scope.scroll.callCount).toEqual(1)

    el.remove()
    scope.$destroy()

  it 'does not trigger when disabled', ->
    scroller = """
    <div infinite-scroll='scroll()' infinite-scroll-distance='1'
      infinite-scroll-disabled='busy' style='height: 500px;'></div>
    """
    el = angular.element(scroller)
    $('body').append(el)

    scope = $rootScope.$new(true)
    scope.scroll = jasmine.createSpy('scroll')
    scope.busy = true
    $compile(el)(scope)
    scope.$digest()

    fakeWindow.scroll()
    expect(scope.scroll).not.toHaveBeenCalled()

    el.remove()
    scope.$destroy()

  it 're-triggers after being re-enabled', ->
    scroller = """
    <div infinite-scroll='scroll()' infinite-scroll-distance='1'
      infinite-scroll-disabled='busy' style='height: 500px;'></div>
    """
    el = angular.element(scroller)
    $('body').append(el)

    scope = $rootScope.$new(true)
    scope.scroll = jasmine.createSpy('scroll')
    scope.busy = true
    $compile(el)(scope)
    scope.$digest()

    fakeWindow.scroll()
    expect(scope.scroll).not.toHaveBeenCalled()

    scope.busy = false
    scope.$digest()
    expect(scope.scroll.callCount).toEqual(1)

    el.remove()
    scope.$destroy()

  it 'only triggers when the page has been sufficiently scrolled down', ->
    scroller = """
    <div infinite-scroll='scroll()'
      infinite-scroll-distance='1' style='height: 10000px'></div>
    """
    el = angular.element(scroller)
    $('body').append(el)

    spyOn(fakeWindow, 'scrollTop').andReturn(7999)

    scope = $rootScope.$new(true)
    scope.scroll = jasmine.createSpy('scroll')
    $compile(el)(scope)
    scope.$digest()
    fakeWindow.scroll()
    expect(scope.scroll).not.toHaveBeenCalled()

    fakeWindow.scrollTop.andReturn(8000)
    fakeWindow.scroll()
    expect(scope.scroll.callCount).toEqual(1)

    el.remove()
    scope.$destroy()

  it 'respects the infinite-scroll-distance attribute', ->
    scroller = """
    <div infinite-scroll='scroll()' infinite-scroll-distance='5' style='height: 10000px;'></div>
    """
    el = angular.element(scroller)
    $('body').append(el)

    spyOn(fakeWindow, 'scrollTop').andReturn(3999)

    scope = $rootScope.$new(true)
    scope.scroll = jasmine.createSpy('scroll')
    $compile(el)(scope)
    scope.$digest()
    fakeWindow.scroll()
    expect(scope.scroll).not.toHaveBeenCalled()

    fakeWindow.scrollTop.andReturn(4000)
    fakeWindow.scroll()
    expect(scope.scroll.callCount).toEqual(1)

    el.remove()
    scope.$destroy()

  it 'responds to the reload-infiniteScroll event', ->
    scroller = """
    <div infinite-scroll='scroll()' style='height: 1000px'
      infinite-scroll-immediate-check='false'></div>
    """
    el = angular.element(scroller)
    $('body').append(el)

    scope = $rootScope.$new(true)
    scope.scroll = jasmine.createSpy('scroll')
    
    $compile(el)(scope)
    $timeout.flush() # 'immediate' call is with $timeout ..., 0
    scope.$broadcast('reload-infiniteScroll')
    expect(scope.scroll.callCount).toEqual(1)

    el.remove()
    scope.$destroy()