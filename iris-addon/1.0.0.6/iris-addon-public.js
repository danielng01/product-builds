var DEFAULT_MODE = "paused";

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
    }
    else if(mode == "deuteranopia")
    {
        document.getElementById("iris-widget-img").src = "https://raw.githubusercontent.com/danielng01/Iris-Builds/master/iris-addon/1.0/img/iris-deuteranopia.png";
		document.getElementById("iris-widget-mode").title = "Deuteranopia";
		pause_iris();
		set_vision_mode("deuteranopia");
    }
    else if(mode == "protanopia")
    {
        document.getElementById("iris-widget-img").src = "https://raw.githubusercontent.com/danielng01/Iris-Builds/master/iris-addon/1.0/img/iris-protanopia.png";
		document.getElementById("iris-widget-mode").title = "Protanopia";
		pause_iris();
		set_vision_mode("protanopia");
    }
    else if(mode == "tritanopia")
    {
        document.getElementById("iris-widget-img").src = "https://raw.githubusercontent.com/danielng01/Iris-Builds/master/iris-addon/1.0/img/iris-tritanopia.png";
		document.getElementById("iris-widget-mode").title = "Tritanopia";
		pause_iris();
		set_vision_mode("tritanopia");
    }
	else if(mode == "paused")
    {
        document.getElementById("iris-widget-img").src = "https://raw.githubusercontent.com/danielng01/Iris-Builds/master/iris-addon/1.0/img/iris-off.png";
		document.getElementById("iris-widget-mode").title = "Paused";
		pause_iris();
		set_vision_mode("paused");
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
	var iris_widget_img = document.getElementById("iris-widget-img");
	iris_widget_img.onload=function(){
		iris_widget_img.style.visibility = "visible";
	};
	iris_widget_img.style.visibility = "hidden";
}

////////////////////////////////////////////////////////////
var is_firefox = navigator.userAgent.toLowerCase().indexOf('firefox') > -1;
if(is_firefox)
{
	window.onscroll = refresh_widget_position;
	window.onresize = refresh_widget_position;
}