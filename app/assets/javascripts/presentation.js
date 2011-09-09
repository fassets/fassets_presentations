DOMBuilder.apply(window);

Presentation = function() {
	var pub = {};
	var transition = {
		show: {
			effect: "frame",
			options: {},
			speed: "normal"
		},
		hide: {
			effect: "frame",
			options: {},
			speed: "normal"
		}
	}
	var _imageIndex = 0;
	var _images = [];
  var _items = [];
	var _frameIndex = null;
	var _pollLocationHash = function() {
		var index = pub.getframeIndex();
		if (_frameIndex != index) {
			if (_frameIndex == null) {
				showframe(index);
			} else {
				doTransition(_frameIndex, index);      
			}
			//console.log("switching from frame #" + _frameIndex + " to #" + index);
			_frameIndex = index;
		}
	}
	function showframe(index) {
		$(".frame[id='" + index + "']").fadeIn("normal");
    $(".frame_menu").find("#"+index).addClass("selected");
    $(".frame_menu").find("#"+index+" a").addClass("selected");
    $(".frame_menu").children().each(function(i,e) {
      if ($(e).has(".selected").length == 0 && $(e).attr("class") != "selected"){
        $(e).children("ol").hide();
      } else {
        $(e).children("ol").show();
      }
    });  
		frame.layout();
		$(".frame[id='" + index + "'] a.zoom").each(function(e){
			_images.push(this);
		});
		_imageIndex = 0;
	}
	function doTransition(from, to) {
		$(".frame[id='" + from + "']").fadeOut("normal", function() {
      $(".frame_menu").find("#"+from).removeClass("selected");
      $(".frame_menu").find("#"+from+" a").removeClass("selected");
      $(".frame_menu").find("#"+to).addClass("selected");
      $(".frame_menu").find("#"+to+" a").addClass("selected");
      showframe(to);
    }
    );        
	}
	pub.getframeIndex = function() {
		return parseInt(location.hash.substring(1)) || 1;
	}
	pub.init = function() {
		$(".frame").hide();
		$(".frame").each(function(i, e){
			var row = TR(TD({"class": "position"}, i + 1), TD($(e).attr("alt")));
			_items.push(row);
		});
    $("#black_dimmer").css("height", $(document).height());
    $("#white_dimmer").css("height", $(document).height());
		setInterval(_pollLocationHash, 200);
	}
	pub.showframe = function(index) {
    if (index > _items.length) {
      alert("frame number "+index+" doesn't exist")
      return;
    }
    if (index < 1) {
      alert("frame numbers begin at 1")
    }
		location.hash = "#" + index;
	}
	pub.nextframe = function() {
    if (_frameIndex == _items.length) return;
		pub.showframe(_frameIndex + 1);
	}
	pub.previousframe = function() {
    if (_frameIndex == 1) return;
		pub.showframe(_frameIndex - 1)
	}
	pub.nextImage = function() {
		$(_images[_imageIndex]).trigger("click");
		_imageIndex++
	}
	pub.previousImage =  function() {
		$(_images[_imageIndex]).trigger("click")
		_imageIndex--		
	}
	return pub;
}();

frame = function() {
	var pub = {};
	pub.width = function() {
		//Try using frame-div-dimensions
    if ($(".frame_menu").is(":visible")){
      return $(window).width() - 250;
    } else {
		  return $(window).width();
    }
	}
	pub.height = function() {
		return $(window).height();
	}
	pub.layout = function() {
//		console.log("layout");
		var size = frame.height() / 32;
	    $("body").css("font-size", size + 'px');
	    $(".frame").css("width", frame.width() + 'px');
	    $(".frame").css("height", frame.height() + 'px');
		$("#" + Presentation.getframeIndex() + " .fit").each(function() {
			if (!$(this).data('dimensions')) {
				$(this).data('dimensions', {
					width: $(this).width(), 
					height: $(this).height(),
					parent: $(this).offsetParent()
				});
			}
			var width = $(this).data('dimensions').width;
			var height = $(this).data('dimensions').height;

			
			var ratio = width/height;
			var parent = $(this).data('dimensions').parent;
			var new_width = 0;
			var new_height = 0;


			if (ratio < (parent.width() / parent.height())) {
				new_height = parent.height();
				new_width = new_height * ratio;
			} else {
				new_width = parent.width();
				new_height = new_width / ratio;									
			}
			$(this).width(new_width);
			$(this).height(new_height);
		});
		
		//Align centered elements
		$(".center").each(function() {
			Slot.center($(this));
		});
		$(".center_v").each(function() {
			Slot.centerVertically($(this));
		});
		$(".center_h").each(function() {
			Slot.centerHorizontally($(this));
		});

	}
	return pub;	
}();

var Slot = {
	init: function(element) {
		if (!element.data('dimensions')) {
			element.data('dimensions', {
				width: element.width(), 
				height: element.height(),
				parent: element.offsetParent()
			});
		}
	},
	centerVertically: function(element) {
		var top = (element.offsetParent().height() - element.height()) / 2;
		element.css("position","absolute");
		element.css("top", top + "px");
	},
	centerHorizontally: function(element) {
		var left = (element.offsetParent().width() - element.width()) / 2;
		element.css("position","absolute");
		element.css("left", left + "px");	
			
	},
	center: function(element) {
		Slot.centerHorizontally(element);
		Slot.centerVertically(element);
	},
	alignLeftIndented: function(element) {
		//Slot.
	}
}
Selector = function() {
	var pub = {};
	
	var _original_dim = {
		"position": "absolute",
		"overflow": "hidden",
		"bottom": "0px",
		"right": "0px",
		"opacity": 0,	
		"width": "0px",
		"height": "0px"
	}
	var _selector = $(DIV({"id": "selector"})).css(_original_dim);

	var _items = [];
	var _list = $(TABLE()).css({
		"position": "absolute"	
	});
	_list.hide();
	var _index = 1;
	function selectframe(i) {
    //console.log("selectframe:"+i);
    $("#selector .selected").removeClass("selected");
    $("tr[frame_number="+i+"]").addClass("selected");		
	}
  pub.init = function() {
    $("[frame_number=0]").addClass("selected");
    $("#selector").hide();
  }
  pub.show = function() {
    if (!pub.isVisible()) {
      var bottom = frame.height() / 2 - frame.height() / 4;
      var width = frame.width() / 2;
      var right = $(window).width() / 2 - width/2;
      var height = frame.height() / 2;
      $("#selector").animate(
				{"bottom": bottom, 
				"right": right, 
				"opacity": 0.98,	
				"width": width, 
				"height": height}, 200, "swing", function() {
					selectframe(Presentation.getframeIndex() - 1);
          $("#selector").show();
				});
    }
  }
	pub.hide = function() {
    $("#selector").animate(_original_dim, 200, "swing", function() {
      $("#selector").hide();
    });
	}
	pub.isVisible = function() {
		return $("#selector").is(":visible");
	}
	pub.previous = function() {
		pub.show();
    _index = parseInt($("#selector .selected").attr("frame_number"));
    if (_index == 0) return;
    _prev_index = _index-1;
    $("#selector .selected").removeClass("selected");
    $("tr[frame_number="+_prev_index+"]").addClass("selected");
	}
	pub.next = function() {
		pub.show();
    _index = parseInt($("#selector .selected").attr("frame_number"));
    frames = parseInt($("#selector table").attr("frames"));
    if (_index == frames) return;
    var _next_index = _index + 1;
    $("#selector .selected").removeClass("selected");
    $("tr[frame_number="+_next_index+"]").addClass("selected");	
	}
  pub.confirm = function() {
    pub.hide();
    _index = parseInt($("#selector .selected").attr("frame_number"));
    Presentation.showframe(_index + 1);
  }
	return pub;
}();


$(function(){
	Presentation.init();
	Selector.init();
  var num = null;
	$(window).keydown(function(event){
		switch(event.keyCode) {
		case 37: //Left
    case 33: //PgUp
			if (!Selector.isVisible()) Presentation.previousframe();
			break;
		case 39: //Right
		case 32: //Space
    case 34: //PgDown
			if (!Selector.isVisible()) Presentation.nextframe();
			break;
		case 38: //Up
			Selector.previous();
			break;
		case 40: //Down
			Selector.next();
			break;
		case 27: //ESC
			Selector.hide();
      if ($("#presentationhelp").attr("style") == "visibility: visible;"){
        $("#presentationhelp").css('visibility','hidden');
      }
			break;
		case 13: //Enter
			if (Selector.isVisible()) Selector.confirm();
      if (num != null) Presentation.showframe(num);
			break;
//		case 49: //1
//			Presentation.previousImage();
//			break;
//		case 50: //2
//			Presentation.nextImage();
//			break;
    case 48: // 0
    case 49: // 1
    case 50: // 2
    case 51: // 3
    case 52: // 4
    case 53: // 5
    case 54: // 6
    case 55: // 7
    case 56: // 8
    case 57: // 9
      if (num == null){  
        num = event.keyCode - 48;
      } else {
        num = 10 * num + event.keyCode - 48;
      }
      setTimeout(function() { num = null;},3000);
      break;
    case 74: // j
      var index = prompt("Jump to frame number:");
      if (index == null) break;
      if (index == "") break;
      Presentation.showframe(index);
      break;
    case 69: // e
      edit_link = document.getElementById(Presentation.getframeIndex()).getElementsByTagName("a")[0];
      location.href = edit_link.href;
      break;
    case 66: // b
    case 83: // s
      if ($("#white_dimmer").is(":visible")){
        $("#white_dimmer").hide();
        $("#black_dimmer").show();
        break;
      }
      if ($("#black_dimmer").is(":visible")){
        $("#black_dimmer").fadeOut();
      } else {
        $("#black_dimmer").fadeIn();
      }
      break;
    case 78: // n
      if ($(".frame_menu").is(":visible")){
        $("#menu").hide("slow", function () {
          frame.layout();
        });
      } else {
          $("#menu").show("slow", function () {frame.layout();});
      }
      break;
    case 87: // w
      if ($("#black_dimmer").is(":visible")){
        $("#black_dimmer").hide();
        $("#white_dimmer").show();
        break;
      }
      if ($("#white_dimmer").is(":visible")){
        $("#white_dimmer").fadeOut();
      } else {
        $("#white_dimmer").fadeIn();
      }
      break; 
		case 72: // h
      if ($("#presentationhelp").attr("style") == "visibility: visible;") {
			  $("#presentationhelp").css('visibility','hidden');
      } else {
        $("#presentationhelp").css('visibility','visible');
      }
			break;     
		}
		console.log(event.keyCode);
	});

	$(window).resize(function(event){
    $("#black_dimmer").css("height", $(window).height());
    $("#white_dimmer").css("height", $(window).height());
		frame.layout();
		Selector.hide();
	});
	
	//Fancy Image Zooming
	$.fn.fancyzoom.defaultsOptions.imgDir='/images/fancyzoom/';
	$.fn.fancyzoom.defaultsOptions.showoverlay=true;
	$('a.zoom').fancyzoom();
});
  