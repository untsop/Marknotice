# Author: UNSTOP ( unstop01@gmail.com )

initOptions = ->
  bgPage = chrome.extension.getBackgroundPage()
  followList = (if localStorage.followList then JSON.parse(localStorage.followList) else {})
  $(".optionBlock input").each ->
    id = $(this).attr("pid")
    $(this).prop "checked", followList[id]
  $(".optionBlock input").change ->
    id = $(this).attr("pid")
    followList[id] = $(this).prop("checked")
    localStorage.followList = JSON.stringify followList
    bkg = chrome.extension.getBackgroundPage()
    bkg.location.reload()
addEventListener "load", initOptions, false