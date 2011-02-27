var Slide = {
	width: function() {
		return $(window).width();
	},
	height: function() {
		return $(window).height();
	},
	syncSize: function() {
		var size = Slide.height() / 30;
	    $("body").css("font-size", size + 'px');
	    $(".slide").css("width", Slide.width() + 'px');
	    $(".slide").css("height", Slide.height() + 'px');

		/*
		$(".fit").each(function() {
			if (!$(this).data('dimensions')) {
				!$(this).data('dimensions', {
					width: $(this).width(), 
					height: $(this).height(),
					parent: $(this).parent()
				});
			}
			var width = $(this).data('dimensions').width;
			var height = $(this).data('dimensions').height;

			
			var ratio = width/height;
			var parent = $(this).data('dimensions').parent;
			var new_width = 0;
			var new_height = 0;


			if (width > height) {
				if (parent.width() > parent.height()) {
					new_height = parent.height();
					new_width = Math.round(new_height * ratio);

				} else {
					new_width = parent.width();
					new_height = new_width / ratio;					
				}
			} else {
				if (parent.width() > parent.height()) {
					new_height = parent.height();
					new_width = new_height / ratio;
				} else {
					new_width = parent.width();
					new_height = new_width * ratio;					
				}
			}
			$(this).width(new_width);
			$(this).height(new_height);
			console.log("" + new_width + "x" + new_height + " parent: " + parent.width() + "x" + parent.height() + " parent_id: " + parent.attr("id"));
		});*/
		
		//Align vertically centered elements
		$(".center_vertically").each(function() {
			var pos = ($(this).parent().height() - $(this).height()) / 2;
			$(this).css("position","absolute");
			$(this).css("top", pos + "px");
		});
	}
}

$(window).ready(function(){
	Slide.syncSize();
});
$(window).resize(function(){
	console.log("resize event")
	Slide.syncSize();
});

/*$(window).ready(function(){
	Slide.syncSize();
});
$(window).resize(function(){
	Slide.syncSize();
});

$("#content").click(function(){
	alert("this.width()");
})*/