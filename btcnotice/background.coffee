# Copyright (c) 2015 yannisxu.me All rights reserved.
# Author: yannisxu ( excellentbright@gmail.com )  

exports = this
exports.markid = localStorage["marknoticeid"]
exports.url = 'https://www.okcoin.cn/market.do'
exports.apiUrl = 'https://www.okcoin.cn/api/v1/ticker.do?symbol=btc_cny'

displayNotice = (data) ->
	current = data.ticker.last
	chrome.bookmarks.update exports.markid, {title: current}

callBitcoinApi = ->
	xhr = new XMLHttpRequest()
	xhr.open "GET", exports.apiUrl, true
	xhr.onreadystatechange = ->
		displayNotice JSON.parse(xhr.responseText)  if xhr.readyState is 4
	xhr.send()
	
checkBitcoin = () ->
	chrome.bookmarks.search 'https://www.okcoin.cn/market.do', (bmk)->
		if bmk[0]
			localStorage["marknoticeid"] = exports.markid = bmk[0].id
			chrome.tabs.create {url: chrome.extension.getURL('/assets/intro_exsit.html') }
		else createNewMark()

createNewMark = () ->
	newMark =
		parentId: '1'
		title: 'Bitcoin'
		url: exports.url
	chrome.bookmarks.create newMark, (r) ->
		localStorage["marknoticeid"] = exports.markid = r.id
		callBitcoinApi()
	chrome.tabs.create {url: chrome.extension.getURL('/assets/intro.html') }

initBackground = () ->
	if exports.markid
  	chrome.bookmarks.get exports.markid, (bookmark) ->
    	if not bookmark
      	localStorage.removeItem exports.markid
				checkBitcoin()
			else
    		checkBitcoin()
	setInterval callBitcoinApi, 30*1000

addEventListener "load", initBackground, false