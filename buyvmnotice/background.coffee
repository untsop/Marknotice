# Copyright (c) 2012 Hubuzhi.com All rights reserved.
# Author: unstop ( unstop01@gmail.com )

exports = this
exports.markid = localStorage["marknoticeid"]
exports.onUrl = 'http://buyvmnotice.sinaapp.com/on.html'
exports.offUrl = 'http://buyvmnotice.sinaapp.com/off.html'
exports.apiUrl = 'http://buyvmnotice.sinaapp.com/buyvmapi.php'

displayNotice = (data) ->
  if data.stock
    updateTitle = "IN STOCK: #{data.total}"
    chrome.bookmarks.update exports.markid, {title: updateTitle, url: exports.onUrl}
  else
    updateTitle = "Out of Stock"
    chrome.bookmarks.update exports.markid, {title: updateTitle, url: exports.offUrl}

callBuyvmApi = ->
  xhr = new XMLHttpRequest()
  xhr.open "GET", exports.apiUrl, true
  xhr.onreadystatechange = ->
    displayNotice JSON.parse(xhr.responseText)  if xhr.readyState is 4
  xhr.send()

createNewMark = () ->
  newMark = 
    title: 'Buyvm Marknotice'
    url: exports.offUrl
  chrome.bookmarks.create newMark, (r) ->
    localStorage["marknoticeid"] = exports.markid = r.id
    callBuyvmApi()
    chrome.tabs.create {url: chrome.extension.getURL('/assets/intro.html') }

initBackground = () ->
  if exports.markid
    chrome.bookmarks.get exports.markid, (bookmark) ->
      if not bookmark
        localStorage.removeItem exports.markid
        createNewMark()
  else
    createNewMark()
  setInterval callBuyvmApi, 60000

addEventListener "load", initBackground, false