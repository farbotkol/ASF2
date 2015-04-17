var $j = jQuery.noConflict();

$j(function() {
    $j( "#tabs" ).tabs({active: getTab('pSubTab')});
    resize();
    if(isSalesforceOne()) {
      $j('#profileProxyLink').hide();
    }
});

Sfdc.canvas.onReady(function() {
    Sfdc.canvas.publisher.subscribe({name : "sfdc.resize", onData : function(e) {
      updateDisplay('sfdc.resize');
      }
    });
});

function resize() {
    Sfdc.canvas.publisher.resize( {width : '100%', height : '3000px'});
}

function updateDisplay(msg) {
    console.log('GOT EVENT IN VF PAGE: ', msg);
}

function setDatePickers() {
    $j('.date').datepicker({
      autoclose: true,
      format: "mm/dd/yyyy",
      todayHighlight: true
    });
}

function setSubTabCookies(tab,level) {
    //Set Expiration to five minutes
    var exp = new Date();
    exp.setTime(exp.getTime() + 300000);
    var expires = "expires="+exp.toGMTString()+";";
    console.log(expires);
    document.cookie=level+"="+tab+";"+expires+"path=/;";
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) != -1) return c.substring(name.length, c.length);
    }
    return "";
}

function getTab(level) {
    var value;
    if(getCookie(level) != "" && !isSalesforceOne()) {
      value = getCookie(level);
    } else if(level == 'pSubTab') {
      value = 1;
    } else {
      value = 0;
    }
    console.log(value);
    return value;
}

function focusField(fieldId) {
    var el = $j('[id$='+fieldId+']').get(0);
    var elemLen = el.value.length;
    
    el.selectionStart = elemLen;
    el.selectionEnd = elemLen;
    el.focus();
}

function isSalesforceOne() {
    if( ( typeof sforce != 'undefined' ) && sforce && sforce.one ) {
      return true;
    } else {
      return false;
    }
}

function helpTextSetup() {
    $j('.helpOrb').each(function() {
          var elem = $j(this);
          elem.qtip({
              content: true,
              events: {
                  show: function(event, api) { elem.parent().removeClass('helpButton').addClass('helpButtonOn');},
                  hide: function(event, api) { elem.parent().removeClass('helpButtonOn').addClass('helpButton');}
              }
          });
    });
}

var inProgress = false;
function resetProgress() {
    inProgress = false;
}

function showSectionSpinner(headerId){
    $j("#"+headerId).toggleClass('active');
}
