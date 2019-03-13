;
(function() {
  function IconGlobalData(json) {
    this.data = JSON.parse(json);

    this.add = function(json, obj) {
      addData(json, obj);
    }

    this.addAndInitIcons = function(json, obj, dontChangeIndex) {
      addData(json, obj, dontChangeIndex);
      initIcons(obj);
    }

    var addData = function(json, obj, dci) {
      var index = Object.keys(iconsData.data).length;
      index = index < 0 ? 0 : index;
      json = json.replace(/_no_index/g, index.toString());
      data = JSON.parse(json);
      this.data = $.extend(true, {}, this.data, data);
      if (!dci) {
        $(obj).closest('.admin-stroke').attr('data-index', index);
      }
    }.bind(this);
  };

  window.iconGlobalDataSet = function(str, dataname) {
    if (dataname == undefined) {
      window.iconsData = new IconGlobalData(str);
    }
    else {
      window[dataname] = new IconGlobalData(str);
    }
  }
})();
