// Generated by CoffeeScript 1.6.1
(function() {
  var checkV2EX, createNewMark, displayNotice, exports, getNotification, initBackground;

  exports = this;

  exports.markid = localStorage["marknoticeid"];

  exports.url = 'http://v2ex.com/';

  exports.noticeUrl = 'http://v2ex.com/notifications';

  exports.apiUrl = 'http://v2ex.com/faq';

  displayNotice = function(data) {
    var count, updateTitle, updateUrl;
    count = 0;
    if (data) {
      count = parseInt(data[1]);
    }
    if (count > 0) {
      updateTitle = "V2EX (" + count + ")";
      updateUrl = exports.noticeUrl;
      return chrome.bookmarks.update(exports.markid, {
        title: updateTitle,
        url: updateUrl
      });
    } else {
      updateTitle = "V2EX";
      updateUrl = exports.url;
      return chrome.bookmarks.update(exports.markid, {
        title: updateTitle,
        url: updateUrl
      });
    }
  };

  getNotification = function() {
    var xhr;
    xhr = new XMLHttpRequest();
    xhr.open("GET", exports.apiUrl, true);
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        return displayNotice(xhr.responseText.match(/FAQ\s\((.*)\)<\/title>/));
      }
    };
    return xhr.send();
  };

  checkV2EX = function() {
    return chrome.bookmarks.search('V2EX', function(bmk) {
      if (bmk[0]) {
        return localStorage["marknoticeid"] = exports.markid = bmk[0].id;
      } else {
        return createNewMark();
      }
    });
  };

  createNewMark = function() {
    var newMark;
    newMark = {
      title: 'V2EX',
      url: exports.url
    };
    chrome.bookmarks.create(newMark, function(r) {
      localStorage["marknoticeid"] = exports.markid = r.id;
      return getNotification();
    });
    return chrome.tabs.create({
      url: chrome.extension.getURL('/assets/intro.html')
    });
  };

  initBackground = function() {
    if (exports.markid) {
      chrome.bookmarks.get(exports.markid, function(bookmark) {
        if (!bookmark) {
          localStorage.removeItem(exports.markid);
          return checkV2EX();
        }
      });
    } else {
      checkV2EX();
    }
    chrome.alarms.onAlarm.addListener(function() {
      return getNotification();
    });
    return chrome.alarms.create({
      periodInMinutes: 1.5
    });
  };

  addEventListener("load", initBackground, false);

  chrome.tabs.onUpdated.addListener(function(tabId, changeInfo) {
    if (changeInfo.url && (changeInfo.url === exports.noticeUrl)) {
      return chrome.bookmarks.get(exports.markid, function(bookmark) {
        var updateTitle, updateUrl;
        if (bookmark[0].url === exports.noticeUrl) {
          updateTitle = "V2EX";
          updateUrl = exports.url;
          return chrome.bookmarks.update(exports.markid, {
            title: updateTitle,
            url: updateUrl
          });
        }
      });
    }
  });

}).call(this);
