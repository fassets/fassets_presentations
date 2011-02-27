// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


DOMBuilder.apply(window);

/*$(document).ajaxSend(function(event, request, settings) {
  if (typeof(AUTH_TOKEN) == "undefined") return;
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});
*/
function id2path(id) {
	return "/" + id.replace(/\./g, "/");
}
function sortSortable(e) {
	var list = $(e);
	$.post(id2path($(e).attr("id")), '_method=put&'+$(e).sortable('serialize'), function() {
		list.effect("highlight");
	});
}
$(function(){
	
	//Fancy Image Zooming
	$.fn.fancyzoom.defaultsOptions.imgDir='/images/fancyzoom/';
	$('a.zoom').fancyzoom();
	$('a.thumbnail').fancyzoom();
	
	//sortable
	var sortable_handle = IMG({'src': '/images/sort.png', 'width': 9, 'height': 9, 'class': 'handle'});
	$("#sidebar ol.sortable li").each(function() {
		$(this).prepend($(sortable_handle).clone());
	});
	
	$("#sidebar ol.sortable").sortable({
		handle: '.handle',
		axis: 'y',
		receive: function(e, ui) {
			console.log("receive");
		},
	 	update: function() {
			var list = $(this);
			$.post(id2path(list.attr("id")), '_method=put&'+list.sortable('serialize'), function() {
				list.effect("highlight");
			});
		}
	});

	
	
	//Collapsable
	$('li.collapsable .content').hide();
	$('li.collapsable').each(function() {
		$(this).prepend(
			$(IMG({
				'src': '/images/collapse.png', 
				'width': 9, 
				'height': 9, 
				'class': 'handle'
			})).click(function() {
				var handle = $(this);
				var content = handle.nextAll('.content');
				if (content.is(":visible")) {
					handle.attr("src", "/images/collapse.png");											
				} else {
					handle.attr("src", "/images/collapsed.png");					
				}
				content.slideToggle("normal");
			})
		);
	});
	
	$('form.collapsable').hide().each(function() {
		var form = $(this);
		form.prevAll('h2:first').append($(IMG({'src': '/images/add.png', 'class': 'handle'})).click(function(){
			form.slideToggle();
		}));
	});
	//Tray sortable
	$('#tray ol').sortable({
		dropOnEmpty: true,
		placeholder:'asset_placeholder',
		handle: '.handle',
		items: 'li',
		zIndex: 5,
		cursor: 'move',
		receive: function(e, ui) {
			console.log("receive");
		},
		update:function(e, ui){
			var id = $(ui.item).attr('id').split('_');
			var add="";
			console.log(id);
			if (id[0] != 'tp') {
				add = "&add_type=" + id[0] + "&add_id=" + id[1];
				$(ui.item).attr('id', "tp_0");
			}
			var user_id = $(this).attr("id").substr(5);
			$.ajax({
				type: "POST",
				url: id2path($(this).attr('id')),
				data: '_method=put&'+$(this).sortable('serialize')+add,
				dataType: 'json',
				success: function(data){
					var tp = data["tray_position"];
					if (tp) {
						if (tp.clipboard_type) {
							var cb = LI({'class': 'clipboard'}, SPAN({'class':'caption'}, "SLIDEXYZ"));
							$(ui.item)
						} else {
							$(ui.item).attr("id", "tp_" + tp.id);
							$(ui.item).append(INPUT({'type':'checkbox', 'name': 'del[]', 'value': tp.id}));
						}
					}
					$('#tray ol').sortable('refresh').effect("highlight");
				},
				error: function() {
					console.log(this.data);
					$("#tp_0").remove();
				}
			});
		}
	});
	
	var tray_toggle = $(A({href: "#", id: "tray_toggle"}, "hide tray")).click(function(e) {
		if ($("#tray ol").slideToggle("normal").is(":hidden")) {
			$(e.target).html("hide tray");
		} else {
			$(e.target).html("show tray");			
		}
	});
	//$('#tray ul').append(tray_toggle);

		
	$('#message').css("top", $(window).scrollTop()).show("slide", {direction: "left"}, 400, function() {
		setTimeout(function() {$('#message').hide("slide", {direction: "left"}, 400);}
		, 4000);
	});
	
	
	$('ul.selector').each(function() {
		var list = $(this);
		var selector = $(SELECT());
		list.find('a').each(function(){
			var opt = $(OPTION({value: $(this).attr('href')}, $(this).html()));
			if ($(this).hasClass('active')) opt.attr("selected", "selected");
			selector.append(opt);
		});
		selector.change(function(e){
			location.href = e.target.value;
		});
		list.replaceWith(selector);
	});
	
	$('#main').append($(DIV({'id': 'edit_warning'}, 'Unsaved changes!')).hide().click(function() {
		$(this).hide();
	}));
	$('#container form input, #container form select, #container form textarea').change(function(){
		$('#edit_warning').show();
	});

	$("[id$='.slides']").droppable({
      accept:'.Slide',
      activeClass:'active',  
      hoverClass:'hover',
      drop:function(ev,ui){
		if ($(ui.draggable).hasClass('Slide')) {
			list = $(this);
			slide_path = $(ui.draggable).find("a.caption").attr("href").split('/');
			
			$.ajax({
				type: "POST",
				url: id2path(list.attr("id")),
				data: "id=" + slide_path[slide_path.length-1],
				dataType: 'json',
				success: function(data){
					console.log(data["slide"]);
					var slide = data['slide'];
					console.log(slide);				
					var item = $(LI({'id': 'slide_' + slide.id, 'class':'slide'}, 
						A({'href': '/presentations/' + slide.presentation_id + '/slides' + slide.id + '/edit'}, slide.title)
					));
					item.prepend($(sortable_handle).clone());
					list.find("ol").append(item);
					list.effect("highlight");
				}
			});	
		}
	  }
    });

});


