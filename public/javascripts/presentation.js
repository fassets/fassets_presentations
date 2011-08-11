DOMBuilder.apply(window);

Presentation = function() {
	var pub = {};
	var transition = {
		show: {
			effect: "slide",
			options: {},
			speed: "normal"
		},
		hide: {
			effect: "slide",
			options: {},
			speed: "normal"
		}
	}
	var _imageIndex = 0;
	var _images = [];
  var _items = [];
	var _slideIndex = null;
	var _pollLocationHash = function() {
		var index = pub.getSlideIndex();
		if (_slideIndex != index) {
			if (_slideIndex == null) {
				showSlide(index);
			} else {
				doTransition(_slideIndex, index);      
			}
			//console.log("switching from slide #" + _slideIndex + " to #" + index);
			_slideIndex = index;
		}
	}
	function showSlide(index) {
		$(".slide[id='" + index + "']").fadeIn("normal");
		Slide.layout();
		$(".slide[id='" + index + "'] a.zoom").each(function(e){
			console.log(this);
			_images.push(this);
		});
		_imageIndex = 0;
	}
	function doTransition(from, to) {
		$(".slide[id='" + from + "']").fadeOut("normal", function() {showSlide(to)});        
	}
	pub.getSlideIndex = function() {
		return parseInt(location.hash.substring(1)) || 1;
	}
	pub.init = function() {
		$(".slide").hide();
		$(".slide").each(function(i, e){
			var row = TR(TD({"class": "position"}, i + 1), TD($(e).attr("alt")));
			_items.push(row);
		});
		setInterval(_pollLocationHash, 200);
	}
	pub.showSlide = function(index) {
    if (index > _items.length) {
      alert("Slide number "+index+" doesn't exist")
      return;
    }
    if (index < 1) {
      alert("Slide numbers begin at 1")
    }
		location.hash = "#" + index;
	}
	pub.nextSlide = function() {
    if (_slideIndex == _items.length) return;
		pub.showSlide(_slideIndex + 1);
	}
	pub.previousSlide = function() {
    if (_slideIndex == 1) return;
		pub.showSlide(_slideIndex - 1)
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

Slide = function() {
	var pub = {};
	pub.width = function() {
		//Try using slide-div-dimensions
		return $(window).width();
	}
	pub.height = function() {
		return $(window).height();
	}
	pub.layout = function() {
		//console.log("layout");
		var size = Slide.height() / 32;
	    $("body").css("font-size", size + 'px');
	    $(".slide").css("width", Slide.width() + 'px');
	    $(".slide").css("height", Slide.height() + 'px');
		$("#" + Presentation.getSlideIndex() + " .fit").each(function() {
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
	var _index = 0;
	function selectSlide(i) {
		$(_items[_index]).removeClass("selected");		
		_index = i;
		$(_items[_index]).addClass("selected");
		
		var pos = (_list.height() / _items.length) * -(_index + 1) + _selector.outerHeight() / 2;
		_list.css("top", pos);
		
	}
	pub.init = function() {
		$(".slide").each(function(i, e){
			var row = TR(TD({"class": "position"}, i + 1), TD($(e).attr("alt")));
			_list.append(row);
			_items.push(row);
		});
		_selector.append(_list);
		_selector.hide();
		$("body").append(_selector);
	}
	pub.show = function() {
		if (!pub.isVisible()) {
			var bottom = Slide.height() / 2 - Slide.height() / 4;
			var right = Slide.width() / 2 -  Slide.width() / 4;
			var width = Slide.width() / 2;
			console.log(width);
			var height = Slide.height() / 2;
			_list.find(".active").removeClass("active");
			$(_items[Presentation.getSlideIndex() - 1]).addClass("active");
			_selector.animate(
				{"bottom": bottom, 
				"right": right, 
				"opacity": 0.98,	
				"width": width, 
				"height": height}, 200, "swing", function() {
					selectSlide(Presentation.getSlideIndex() - 1);
					_list.show();
          _selector.show();
				});
			return true;
		}
		return false;
	}
	pub.hide = function() {
		_selector.animate(_original_dim, 200, "swing", function() {
			_list.hide();
			_selector.hide();
		});
	}
	pub.isVisible = function() {
		return _selector.is(":visible");
	}
	pub.previous = function() {
		pub.show();
		if (_index == 0) return;
		selectSlide(_index - 1);
	}
	pub.next = function() {
		pub.show();
		if (_index == _items.length - 1) return;
		selectSlide(_index + 1);		
	}
	pub.confirm = function() {
		pub.hide();
		Presentation.showSlide(_index + 1);
	}
	return pub;
}();


$(function(){
	Presentation.init();
	Selector.init();
	$(window).keydown(function(event){
		switch(event.keyCode) {
		case 37: //Left
    case 33: //PgUp
			if (!Selector.isVisible()) Presentation.previousSlide();
			break;
		case 39: //Right
		case 32: //Space
    case 34: //PgDown
			if (!Selector.isVisible()) Presentation.nextSlide();
			break;
		case 38: //Up
			Selector.previous();
			break;
		case 40: //Down
			Selector.next();
			break;
		case 27: //ESC
			Selector.hide();
			break;
		case 13: //Enter
			if (Selector.isVisible()) Selector.confirm();
			break;
		case 49: //1
			Presentation.previousImage();
			break;
		case 50: //2
			Presentation.nextImage();
			break;
    case 74: // j
      var index = prompt("Jump to slide number:");
      if (index == null) break;
      if (index == "") break;
      Presentation.showSlide(index);
      break;
		}
		console.log(event.keyCode);
	});

	$(window).resize(function(event){
		Slide.layout();
		Selector.hide();
	});
	
	//Fancy Image Zooming
	$.fn.fancyzoom.defaultsOptions.imgDir='/images/fancyzoom/';
	$.fn.fancyzoom.defaultsOptions.showoverlay=true;
	$('a.zoom').fancyzoom();
});
  
