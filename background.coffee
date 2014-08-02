# Copyright 2014 wtwf.com, All Rights Reserved.
# Created by: Alex K (wtwf.com)

# Nothing to see here
# icon from: http://pixabay.com/en/ark-flat-icon-mark-all-select-27110/
# https://developer.chrome.com/extensions/storage
# https://developer.chrome.com/extensions/windows

log = ->
  console.log(arguments...)

lastSize = ''
lastSizeUpdate = 0

checkSizes = ->
  currentSize = "#{window.screen.width}x#{window.screen.height}"
  if currentSize == lastSize && new Date().getTime() - lastSizeUpdate < 30000
    log('***** NO SIZE CHANGE (too fresh)')
    return

  chrome.storage.local.get(null, (items) ->
    if currentSize == lastSize
      log('***** NO SIZE CHANGE items/last/current:',
          items, lastSize, currentSize)
      lastSizeUpdate = new Date().getTime()
      # just update the windows
      data = items[currentSize] || {}
      chrome.windows.getAll({}, (wins) ->
        log('windows:', wins)
        for w in wins
          data[w.id] = {
            left: w.left
            top: w.top
            width: w.width
            height: w.height
          }
        # now find best data
        bestId = data.bestId
        if !data[bestId]
          bestId = wins[0].id
        for w in wins
          if (w.id != bestId &&
              w.width * w.height > data[bestId].width * data[bestId].height)
            bestId = w.id
        data.bestId = bestId
        items[currentSize] = data
        chrome.storage.local.set(items, ->
          log('new items', items)
          # chrome.storage.local.set({lastSize: '10x10'})
        )
      )
    else
      log('----- SIZE CHANGED from/to', lastSize, currentSize)
      lastSize = currentSize
      chrome.windows.getAll({}, (wins) ->
        data = items[currentSize] || {}
        for w in wins
          id = if data[w.id] then w.id else data.bestId
          log('w.id/id/bestid', w.id, id, data.bestId)
          chrome.windows.update(w.id, {
            top: data[id].top
            left: data[id].left
            width: data[id].width
            height: data[id].height
          })
      )
  )

checkSizes()
window.setInterval(checkSizes, 5000)
