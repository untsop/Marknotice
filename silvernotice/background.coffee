# Copyright (c) 2012 Hubuzhi.com All rights reserved.
# Author: unstop ( unstop01@gmail.com )

exports = this
exports.markid = localStorage["marknoticeid"]
exports.url = 'http://sp.hubuzhi.com/'
exports.apiUrl = 'http://sp.hubuzhi.com/silverapi.php'

displayNotice = (data) ->
  current = data[2]
  changePercent = data[4]
  unless changePercent.indexOf("-") >= 0
    updateTitle = "▲ #{changePercent}: #{current}"
  else
    updateTitle = "▼ #{changePercent}: #{current}"
  chrome.bookmarks.update exports.markid, {title: updateTitle}

callSilverApi = ->
  xhr = new XMLHttpRequest()
  xhr.open "GET", exports.apiUrl, true
  xhr.onreadystatechange = ->
    displayNotice JSON.parse(xhr.responseText)  if xhr.readyState is 4
  xhr.send()

createNewMark = () ->
  newMark = 
    title: 'Silver Price'
    url: exports.url
  chrome.bookmarks.create newMark, (r) ->
    localStorage["marknoticeid"] = exports.markid = r.id
    callSilverApi()

initBackground = () ->
  if exports.markid
    chrome.bookmarks.get exports.markid, (bookmark) ->
      if not bookmark
        localStorage.removeItem exports.markid
        createNewMark()
  else
    createNewMark()
  setInterval callSilverApi, 60000

addEventListener "load", initBackground, false