;
(function(window) {
  /* Initialize your app here */
  window.listenNetworkStatusChangeCallback;

  window.App = {

    /* appCopyString */
    appCopyString: function(object) {
      window.KKJSBridge.call('default', 'appCopyString', object, function responseCallback(responseData) {});
    },


    /* showWaterMark */
    showWaterMark: function() {
      window.KKJSBridge.call('default', 'showWaterMark', {}, function responseCallback(res) {});
    },

    /* openWebUrl */
    openWebUrl: function(object) {
      if (object.url) {
        window.KKJSBridge.call('default', 'openWebUrl', object, function responseCallback(res) {});
      }
    },

    /* allowWebBackForwardGesture */
    allowWebBackForwardGesture: function(object) {
      window.KKJSBridge.call('default', 'allowWebBackForwardGesture', {
          'allow': object
        },
        function responseCallback(res) {});
    },

    /* showToast */
    showToast: function(object) {
      var content = object.content;
      if (content == null || content.length == 0) {
        object.fail();
      } else {
        var duration = object.duration ? object.duration : 1.5;
        window.KKJSBridge.call('default', 'showToast', {
          'content': content,
          'duration': duration
        }, function responseCallback(responseData) {
          if (responseData.success) {
            object.success();
          } else {
            object.fail();
          }
        });
      }

    },

    /* callPhone */
    callPhone: function(object) {
      var number = object.number;
      window.KKJSBridge.call('default', 'callPhone', {
        'number': number
      }, function responseCallback(responseData) {
        if (responseData.success) {
          object.success();
        } else {
          object.fail();
        }
      });
    },

    /* showModal */
    showModal: function(object) {
      var title = object.title ? object.title : '';
      var content = object.content ? object.content : '';
      var confirmText = object.confirmText ? object.confirmText : '';
      var showCancel = object.showCancel;
      if (showCancel == null) {
        showCancel = false;
      }
      var cancelText = object.cancelText ? object.cancelText : '';
      window.KKJSBridge.call('default', 'showModal', {
        'title': title,
        'content': content,
        'showCancel': showCancel,
        'cancelText': cancelText
      }, function responseCallback(responseData) {
        if (responseData.success) {
          object.success(responseData);
        } else {
          object.fail();
        }
      });

    },

    /* showActionSheet */
    showActionSheet: function(object) {
      var title = object.title ? object.title : '';
      var content = object.content ? object.content : '';
      var menus = object.menus;
      if (menus == null) {
        object.fail();
      } else {
        window.KKJSBridge.call('default', 'showActionSheet', {
          'title': title,
          'content': content,
          'menus': menus
        }, function responseCallback(responseData) {
          if (responseData.success) {
            object.success(responseData);
          } else {
            object.fail();
          }
        });
      }
    },

    /* getInfo */
    getInfo: function(object) {
      window.KKJSBridge.call('default', 'getInfo', {}, function responseCallback(responseData) {
        object.finish(responseData);
      });
    },

    /* setTitle */
    setTitle: function(object) {
      var title = object.title ? object.title : '';
      window.KKJSBridge.call('default', 'setTitle', {
        'title': title
      }, function responseCallback(responseData) {
        if (responseData.success) {
          object.success();
        } else {
          object.fail();
        }
      });
    },

    /* getNetworkStatus */
    getNetworkStatus: function(object) {
      window.KKJSBridge.call('default', 'getNetworkStatus', {}, function responseCallback(responseData) {
        object.finish(responseData);
      });
    },

    /* listenNetworkStatusChange */
    listenNetworkStatusChange: function(callback) {
      window.listenNetworkStatusChangeCallback = callback;
      window.KKJSBridge.call('default', 'listenNetworkStatusChange', {}, function responseCallback(responseData) {});
    },

    /* listenBtnBackClicked */
    listenBtnBackClicked: function() {

    },

    /* exit */
    exit: function() {
      window.KKJSBridge.call('default', 'exit', {}, function responseCallback(res) {});
    },

    /* getPlatform */
    getPlatform: function() {
      return 'iOS';
    },

    /* getPlatForm */
    getPlatForm: function() {
      return 'iOS';
    },

    /* canIUse */
    canIUse: function(functionName) {
      var args = {
        type: "SyncFunc",
        name: "canIUse" + "__symbol__" + functionName
      };
      var argsString = JSON.stringify(args);
      var result = prompt(argsString);
      return Boolean(result);
    }
  };

  window.KKJSBridge.on('listenNetworkStatusChangeCallback', function(data, responseCallback) {
    window.listenNetworkStatusChangeCallback(data);
  });
  if (typeof AppDidFinishLoad == 'function') {
    AppDidFinishLoad();
  }
})(window);
