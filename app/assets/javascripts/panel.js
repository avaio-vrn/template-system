//= require panel_animate

;(function(){
  function PanelChangeTab(){
    this.mainTab = true;

    this.changeMainTab = function(){
      this.mainTab = !this.mainTab;
    };
    this.switchTab = function(el){
      $('.admin-top-link--active').removeClass('admin-top-link--active');
      $(el).addClass('admin-top-link--active');
      this.changeMainTab();
      if(this.mainTab){
        $('.js__main-panel').removeClass('invisible');
        $('.js__add-panel').addClass('invisible');
      }
      else{
        $('.js__main-panel').addClass('invisible');
        $('.js__add-panel').removeClass('invisible');
      }
    }

    $('.js__tab-link').on('click', { panel: this }, function(event){
      if($(event.target).hasClass('admin-top-link--active')){
        event.preventDefault();
        event.stopPropagation();
      }
      else{ event.data.panel.switchTab(event.target); }
    });

  }

  function Panel(side){
    var otherSide = (side =='left') ? 'right' : 'left'

    this.change_state_uri = '/admin/panel/';
    this.open_class = 'ts-admin-panel-link--open';
    this.close_class = 'ts-admin-panel-link--close';
    this.opened = $('body').hasClass('openpanel') && $('body').hasClass('open-' + side);

    this.open_close_button = $('.ts-admin-panel--' + side).find('.js__panel-state');
    this.open_close_button.addClass(this.opened ? this.close_class : this.open_class);
    this.open_close_button.on('click', { panel: this }, function(event){
      var panel = event.data.panel;
      var request = $.ajax({
        type: 'GET',
        url: panel.change_state_uri + +!panel.opened,
        dataType: 'json',
        data: { leftSide: side == 'left' }
      });
      request.done(function(msg){
        panel.opened = !panel.opened;
        if (panel.opened) {
          $('body').addClass('openpanel open-' + side);
          panel.open_close_button.removeClass(panel.open_class);
          panel.open_close_button.addClass(panel.close_class);
        }
        else {
          $('body').removeClass('open-' + side);
          if(!$('body').hasClass('open-' + otherSide)) { $('body').removeClass('openpanel'); }
          panel.open_close_button.removeClass(panel.close_class);
          panel.open_close_button.addClass(panel.open_class);
        }
        window.variables.panelBottom.trigger('TS.panel.resize');
      })
    });

    if($('.ts-admin-panel--' + side).find('.admin-top-link').length > 0) { new PanelChangeTab() }

  }

  var panelBottomWidth = function(){
    var bottomPanel = $('.ts-admin-panel--bottom');
    var width = document.body.clientWidth;

    if ($('body').hasClass('open-left')){
      width = width - PANEL_CONST.leftPanel.width;
      bottomPanel.css('transform','translateX(' + (PANEL_CONST.leftPanel.width + PANEL_CONST.closeLinkWidth) + 'px)');
    }
    else
    {
      bottomPanel.css('transform', 'translateX(' + PANEL_CONST.closeLinkWidth + 'px)');
    }

    if ($('body').hasClass('open-right')){
      width = width - PANEL_CONST.rightPanel.width;
    }

    bottomPanel.width(width - 2 * PANEL_CONST.closeLinkWidth);
    if(width < 910 - 2 * PANEL_CONST.closeLinkWidth) { bottomPanel.addClass('temp-part--half'); }
  }

  window.initAdminPanel = function(){
   $('.ts-admin-container').css('transition', 'margin 0.4s ease, padding 0.4s ease');

    new Panel('left');
    new Panel('right');

    panelBottomWidth();

    $('.js__panel-link-save').off('click').on('click', function(){
      window.variables.TsForm.submit();
    });

    if($('.ts-admin-panel--bottom > div').length > 0) { window.variables.panelBottom.trigger('TS.panel.bottom.show') }
  }

  window.variables.panelBottom.off('TS.panel.resize').on('TS.panel.resize', function(){ panelBottomWidth() })
  window.variables.panelBottom.on('TS.panel.resize', function(){ calculateMarginContent() })
})();



