# Copyright (c) 2012 mi93.com All rights reserved.
# Author: unstop ( unstop01@gmail.com )

exports = this
exports.markid = localStorage["marknoticeid"]
exports.url = 'http://v2ex.com/'
exports.noticeUrl = 'http://v2ex.com/notifications'
exports.apiUrl = 'http://v2ex.com/faq'

displayNotice = (data) ->
	count = 0
	if data
		count = parseInt(data[1])
	if ( count > 0 )
		updateTitle = "V2EX (#{count})"
		updateUrl = exports.noticeUrl
		chrome.bookmarks.update exports.markid, {title: updateTitle, url: updateUrl}
	else
		updateTitle = "V2EX"
		updateUrl = exports.url
		chrome.bookmarks.update exports.markid, {title: updateTitle, url: updateUrl}

getNotification = ->
	xhr = new XMLHttpRequest()
	xhr.open "GET", exports.apiUrl, true
	xhr.onreadystatechange = ->
		displayNotice xhr.responseText.match(/FAQ\s\((.*)\)<\/title>/)  if xhr.readyState is 4
	xhr.send()

checkV2EX = () ->
	chrome.bookmarks.search 'V2EX', (bmk)->
		if bmk[0]
			localStorage["marknoticeid"] = exports.markid = bmk[0].id
		else createNewMark()

createNewMark = () ->
	newMark = 
		title: 'V2EX'
		url: exports.url
	chrome.bookmarks.create newMark, (r) ->
		localStorage["marknoticeid"] = exports.markid = r.id
		getNotification()
	chrome.tabs.create {url: chrome.extension.getURL('/assets/intro.html') }

initBackground = () ->
	if exports.markid
		chrome.bookmarks.get exports.markid, (bookmark) ->
			if not bookmark
				localStorage.removeItem exports.markid
				checkV2EX()
	else
		checkV2EX()
	chrome.alarms.onAlarm.addListener ->
		getNotification()
	chrome.alarms.create
		periodInMinutes: 1.5

addEventListener "load", initBackground, false

chrome.tabs.onUpdated.addListener (tabId, changeInfo) ->
	if changeInfo.url and (changeInfo.url is exports.noticeUrl)
		chrome.bookmarks.get exports.markid, (bookmark) ->
			if bookmark[0].url is exports.noticeUrl
				updateTitle = "V2EX"
				updateUrl = exports.url
				chrome.bookmarks.update exports.markid, {title: updateTitle, url: updateUrl}