$(function(){
	
	var drag_opts = {
		handle: ".handle",
		helper: "clone",
		connectToSortable: "#tray ol",
		start:function(e, ui) {
			$('#tray ol').addClass("active");
		}, 
		stop:function(e, ui) {
			$('#tray ol').removeClass("active");
		}
	}
	$('li.slot').droppable({
      accept:'.asset',
      activeClass:'active',  
      hoverClass:'hover',
      drop:function(ev,ui){
		var id;
		var asset = $(ui.draggable).clone();
		if ($(ui.draggable).is("[id^='tp']")) {
			id = $(ui.draggable).attr("rel");
			asset.find("input").remove();
			asset.attr("id", "asset_" + id);
		} else {
			id = $(ui.draggable).attr("id").split('_')[1];
		}
		asset.removeAttr("style");
		asset.find(".icon a.zoom").fancyzoom();
		$(asset).draggable(drag_opts);
		$(this).find(".content .slot_asset").empty().append(asset).show();
		$(this).find(".content input").val(id);
		$(this).find(".content textarea").hide();
		$(this).find(".name select").val("asset");
		$('#edit_warning').show();
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
	$("#slots li.asset").draggable(drag_opts);
});