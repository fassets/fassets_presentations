$(function(){
	
	var drag_opts = {
		handle: ".handle",
		helper: "clone",
		connectToSortable: "#tray ol",
    appendTo: "body",  
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
		$(this).find(".content input").val(id);
		$(this).find(".content textarea").hide();
		$(this).find(".name select").val("asset");
    $(this).find(".content .slot_asset").load('/file_assets/'+id+'/preview','asset_id=' + id, function(){
      $("img.fit").scaleImage({
        parent: ".slot_asset",
        scale: 'fit',
        center: false
      });
      $("img.fit").draggable(drag_opts);
    });
    edit_link = '<a href="/file_assets/'+id+'/edit"><img width="15" height="15" src="/images/edit.png?1298906686" alt="Edit"></a>'
    $(this).find(".name a").html(edit_link);
    $(this).find(".content .slot_asset").show();
		$('#edit_warning').css('visibility','visible');
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
      $("img.fit").scaleImage({
        parent: ".slot_asset",
        scale: 'fit',
        center: false
      });
			text.hide();
		}
	});
  $(".asset").draggable(drag_opts);
  $("select").change(function(){
    $('#edit_warning').css('visibility','visible');
  });
});
