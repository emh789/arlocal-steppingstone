Arlocal.FrontEnd = {

  _onReady: {
    initialize: function() {
      this._addElementEventListeners();
      this._updateElementData();
      return true;
    },
    _addElementEventListeners: function() {
      $(document).on('click', '.arl_active_link_container[data-url]', function(event) { Arlocal.FrontEnd.elementEvents.linkContainer.click(event) } );
      $(document).on('change', '.arl_active_refine_selection', function(event) { Arlocal.FrontEnd.elementEvents.linkFilterSelect.change(event, 'data-url') } );
      $(document).on('change', '.arl_active_select', function(event) { Arlocal.FrontEnd.elementEvents.linkFilterSelect.change(event, 'data-url') } );
      return true;
    },
    _updateElementData: function() {
      var emailAddresses = document.querySelectorAll('a.arl_active_address_email');
      emailAddresses.forEach(function(addr) {
        Arlocal.FrontEnd.elementData.contactInfo.anchor.text_fill(addr);
      });
      return true;
    }
  },

  elementEvents: {
    linkContainer: {
      click: function(event) {
        event.preventDefault();
        var target = event.target;
        if (target.classList.contains('arl_active_link_container')) {
          var url = target.getAttribute('data-url');
        } else {
          var parentRow = target.closest('.arl_active_link_container[data-url]');
          var url = parentRow.getAttribute('data-url');
        }
        window.location.href = url;
        return true;
      }
    },
    linkFilterSelect: {
      change: function(event, attribute) {
        event.preventDefault();
        var select = event.target;
        var index = select.selectedIndex;
        var options = select.getElementsByTagName('OPTION');
        var option = options[index];
        var url = option.getAttribute(attribute);
        window.location.href = url;
        return true;
      }
    }
  },

  elementData: {
    contactInfo: {
      anchor: {
        text_fill: function(anchor) {
          var recipient = anchor.getAttribute('data-recipient');
          var domain = anchor.getAttribute('data-domain');
          var address = (recipient + '@' + domain);
          var href = ('mailto:' + address);
          anchor.textContent = address;
          anchor.setAttribute('href', href);
          return true;
        }
      }
    }
  }

};
