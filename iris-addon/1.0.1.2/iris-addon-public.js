var DEFAULT_MODE = "paused";

////////////////////////////////////////////////////////////
function autoload_iris_addon_from_php(autoload)
{
    var oReq = new XMLHttpRequest(); //New request object
    oReq.onload = function() {
        //This is where you handle what to do with the response.
        //The actual data is found on this.responseText
        console.log(this.responseText);
    };
    oReq.open("GET", "https://iristech.co/autoload_iris_addon.php?autoload=" + autoload, true); //Don't block the rest of the execution. Don't wait until the request finishes to continue.
    oReq.send();
}

////////////////////////////////////////////////////////////
function wait_for_iris_addon_load(script)
{
	//for non-IE browsers
	script.onload = function () {
		console.log('loaded non ie');
		refresh_iris_addon_mode();
	};
	//for IE Browsers
	ie_load_bug_fix(script, function () {
		console.log('loaded IE');
		refresh_iris_addon_mode();
	});

}

////////////////////////////////////////////////////////////
function ie_load_bug_fix(scriptElement, callback){
	if (scriptElement.readyState=='loaded' || scriptElement.readyState=='completed') {
		callback();
	}else {
		setTimeout(function() {ie_load_bug_fix(scriptElement, callback); }, 100);
	}
}

////////////////////////////////////////////////////////////
function add_iris_addon_if_needed()
{
	var mode = DEFAULT_MODE;
	if (localStorage.getItem("iris-mode") != null)
	{
		mode = localStorage.getItem("iris-mode");
	}
	if (mode != "paused")
	{
		var ia_script = document.getElementById("ia-main");
		if (!ia_script) 
		{
			ia_script = document.createElement('script');
			ia_script.id = "ia-main";
			//ia_script.src = "js/index.js";
			ia_script.src = "https://cdn.rawgit.com/danielng01/Iris-Builds/master/iris-addon/1.0.1.1/main.min.js";
			//document.head.appendChild(ia_script);
			//document.body.appendChild(ia_script);
			wait_for_iris_addon_load(ia_script);
			document.documentElement.appendChild(ia_script);
		}
	}	
}

////////////////////////////////////////////////////////////
add_iris_addon_if_needed();

////////////////////////////////////////////////////////////
function iris_set_temperature(value)
{
	var iris_event = new CustomEvent("set_semperature",
	{
		detail: {
			temperature: value
		}
	});
	document.dispatchEvent(iris_event);	
}

////////////////////////////////////////////////////////////
function pause_iris()
{
	var iris_event = new CustomEvent("pause_iris",
	{
		detail: {
			paused: true
		}
	});
	document.dispatchEvent(iris_event);	
}

////////////////////////////////////////////////////////////
function unpause_iris()
{
	var iris_event = new CustomEvent("pause_iris",
	{
		detail: {
			paused: false
		}
	});
	document.dispatchEvent(iris_event);	
}

////////////////////////////////////////////////////////////
function set_vision_mode(new_mode)
{
	var iris_event = new CustomEvent("set_vision_mode",
	{
		detail: {
			mode: new_mode
		}
	});
	document.dispatchEvent(iris_event);	
}

document.addEventListener('DOMContentLoaded', refresh_iris_addon_mode, false);
////////////////////////////////////////////////////////////
function refresh_iris_addon_mode()
{
	var mode = DEFAULT_MODE;
	if(localStorage.getItem("iris-mode") != null)
    {
		mode = localStorage.getItem("iris-mode");
    }
	
	var is_safari = !!navigator.userAgent.match(/Version\/[\d\.]+.*Safari/);
	if(is_safari)
	{
		refresh_widget_img();
	}
	
	if(mode == "automatic")
    {
        document.getElementById("iris-widget-img").src = "https://raw.githubusercontent.com/danielng01/Iris-Builds/master/iris-addon/1.0/img/iris-on.png";
		document.getElementById("iris-widget-mode").title = "Eye Protection";
		unpause_iris();
		set_vision_mode("paused");
		autoload_iris_addon_from_php(true);
    }
    else if(mode == "deuteranopia")
    {
        document.getElementById("iris-widget-img").src = "https://raw.githubusercontent.com/danielng01/Iris-Builds/master/iris-addon/1.0/img/iris-deuteranopia.png";
		document.getElementById("iris-widget-mode").title = "Deuteranopia";
		pause_iris();
		set_vision_mode("deuteranopia");
		autoload_iris_addon_from_php(true);
    }
    else if(mode == "protanopia")
    {
        document.getElementById("iris-widget-img").src = "https://raw.githubusercontent.com/danielng01/Iris-Builds/master/iris-addon/1.0/img/iris-protanopia.png";
		document.getElementById("iris-widget-mode").title = "Protanopia";
		pause_iris();
		set_vision_mode("protanopia");
		autoload_iris_addon_from_php(true);
    }
    else if(mode == "tritanopia")
    {
        document.getElementById("iris-widget-img").src = "https://raw.githubusercontent.com/danielng01/Iris-Builds/master/iris-addon/1.0/img/iris-tritanopia.png";
		document.getElementById("iris-widget-mode").title = "Tritanopia";
		pause_iris();
		set_vision_mode("tritanopia");
		autoload_iris_addon_from_php(true);
    }
	else if(mode == "paused")
    {
        document.getElementById("iris-widget-img").src = "https://raw.githubusercontent.com/danielng01/Iris-Builds/master/iris-addon/1.0/img/iris-off.png";
		document.getElementById("iris-widget-mode").title = "Paused";
		pause_iris();
		set_vision_mode("paused");
		autoload_iris_addon_from_php(false);
    }	
	
	var is_firefox = navigator.userAgent.toLowerCase().indexOf('firefox') > -1;
	if(is_firefox)
	{
		refresh_widget_position();
	}
}

////////////////////////////////////////////////////////////
function iris_addon_switch_mode()
{
	//console.log("iris_addon_switch_mode");
		
	var mode = DEFAULT_MODE;
	if(localStorage.getItem("iris-mode") != null)
	{
		mode = localStorage.getItem("iris-mode");
	}

	if(mode == "automatic")
	{
		mode = "deuteranopia";
	}
	else if(mode == "deuteranopia")
	{
		mode = "protanopia";
	}
	else if(mode == "protanopia")
	{
		mode = "tritanopia";
	}
	else if(mode == "tritanopia")
	{
		mode = "paused";
	}
	else if(mode == "paused")
	{
		mode = "automatic";
	}
	else
	{
		mode = "automatic";
	}
	
	localStorage.setItem("iris-mode", mode);
	add_iris_addon_if_needed();
	refresh_iris_addon_mode();
}

////////////////////////////////////////////////////////////
function refresh_widget_position()
{
	var iris_widget = document.getElementById("iris-widget");
	iris_widget.style.top = window.innerHeight + document.documentElement.scrollTop - 60 + "px";
}

////////////////////////////////////////////////////////////
function refresh_widget_img()
{
	var iris_widget = document.getElementById("iris-widget");
	var iris_widget_img = document.getElementById("iris-widget-img");
	iris_widget_img.onload=function(){
		//iris_widget.style.boxShadow = "0 3px 12px rgba(0,0,0,.15)";
		iris_widget.style.bottom = "10px";
	};
	//iris_widget.style.boxShadow = "0 3px 13px rgba(0,0,0,.15)";
	iris_widget.style.bottom = "11px";
}

////////////////////////////////////////////////////////////
var is_firefox = navigator.userAgent.toLowerCase().indexOf('firefox') > -1;
if(is_firefox)
{
	window.onscroll = refresh_widget_position;
	window.onresize = refresh_widget_position;
}