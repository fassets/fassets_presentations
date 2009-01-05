$(function(){
	$('li.slot').droppable({
      accept:'.asset',
      activeClass:'active',  
      hoverClass:'hover',
      drop:function(ev,ui){
		var id = $(ui.draggable).attr("rel");
		var asset = $(ui.draggable).clone();
		asset.removeAttr("style");
		asset.find(".icon a.zoom").fancyzoom();
		$(this).find(".content .slot_asset").empty().append(asset).show();
		$(this).find(".content input").val(id);
		$(this).find(".content textarea").hide();
		$(this).find(".handle select").val("asset");
      },
    });
	$("button.drop_slot").click(function(){
		$(this).parent().parent().remove();
	});
	
	$('#slots select').change(function(){
		var content = $(this).parent().next();
		var text = content.find("textarea");
		var asset = content.find(".slot_asset");
		if ($(this).val() == "markup") {
			asset.hide();
			text.show();
		} else {
			asset.show();
			text.hide();
		}
	});
});