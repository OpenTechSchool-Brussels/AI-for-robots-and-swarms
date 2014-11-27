
var addEvent = function(elem, type, eventHandle) {
    if (elem == null || typeof(elem) == 'undefined') return;
    if ( elem.addEventListener ) {
        elem.addEventListener( type, eventHandle, false );
    } else if ( elem.attachEvent ) {
        elem.attachEvent( "on" + type, eventHandle );
    } else {
        elem["on"+type]=eventHandle;
    }
};

addEvent(window, "resize", function() {
                        
                          //alert("d width =" + window.innerWidth);
                          if(window.innerWidth < 702) {
                            document.getElementById("p_menu").style.width ="100%";
                            document.getElementById("p_content").style.width = "100%";
                          } else {
                            document.getElementById("p_menu").style.width = "23%";
                            document.getElementById("p_content").style.width = "69%";
                          }
                        }

);


addEvent(window, "load", function() {
                        
                          //alert("d width =" + window.innerWidth);
                          if(window.innerWidth < 702) {
                            document.getElementById("p_menu").style.width ="100%";
                            document.getElementById("p_content").style.width = "100%";
                          } else {
                            document.getElementById("p_menu").style.width = "23%";
                            document.getElementById("p_content").style.width = "69%";
                          }
                        }

);
