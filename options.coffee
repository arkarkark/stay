# Copyright 2014 wtwf.com, All Rights Reserved.
# Created by: Alex K (wtwf.com)
#
# https://developer.chrome.com/extensions/windows

angular.module('stay', [])

angular.module('stay').controller('StayController',
['$window', (
  $window)->
  @foo = 'hello'

  @screen = {
    width: $window.screen.width
    height: $window.screen.height
  }

  @window = {}


  @doit = =>
    chrome.windows.getCurrent(null, (w) =>
      @window = w
        # chrome.windows.update(w.id, {
          # top: 100
          # left: 100
          # width: 880
          # height: 500
        # })
    )

  @
])
