$(function(){
	
	var drag_opts = {
		handle: ".handle",
		//helper: "clone",
    cursorAt: {top: 48,left: 48},
		connectToSortable: "#tray ol",
    appendTo: "body",
    helper: function(){
      var asset = $(this).clone();
      asset.css("width",96);
      asset.css("height",96);
      return $(asset);
    },  
		start:function(e, ui) {
			$('#tray ol').addClass("active");
		}, 
		stop:function(e, ui) {
      $(this).parent().parent().parent().parent().find(".content input").val("");
		  $(this).parent().parent().parent().parent().find(".content .slot_asset").html("Drop Asset here!");
      $(this).parent().parent().parent().parent().find(".name a").remove();
      $(this).parent().parent().parent().parent().find(".name .drop_asset").remove();
			$('#tray ol').removeClass("active");
		}
	}
	var drag_opts_tray = {
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
    $(this).find(".content .slot_asset").load('/assets/'+id+'/preview', function(){
      $("img.fit").scaleImage({
        parent: ".slot_asset",
        scale: 'fit',
        center: false
      });
      $(".asset").draggable(drag_opts);
    });
    edit_link = '<a href="/assets/'+id+'/edit?asset_id='+id+'"><img width="15" height="15" src="/images/edit.png?1298906686" alt="Edit" title="Edit"></a>'
    drop_link = '<img width="15" height="15" src="/images/delete.png?1298906686" class="drop_asset">'
    if ($(this).find(".name a").length){
      $(this).find(".name a").html(edit_link);
    } else {
      $(this).find(".name").append(edit_link);
    }
    if (!$(this).find(".name .drop_asset").length){
      $(this).find(".name").append(drop_link);
	    $(".drop_asset").click(function(){
        $(this).parent().parent().find(".content input").val("");
		    $(this).parent().parent().find(".content .slot_asset").html("Drop Asset here!");
        $(this).parent().parent().find(".name a").remove();
        $(this).parent().parent().find(".name .drop_asset").remove();
        $('#edit_warning').css('visibility','visible');
	    });
    }
    $(this).find(".content .slot_asset").show();
		$('#edit_warning').css('visibility','visible');
      },
    });
	$("button.drop_slot").click(function(){
		$(this).parent().parent().remove();
	});
	$(".drop_asset").click(function(){
    $(this).parent().parent().find(".content input").val("");
		$(this).parent().parent().find(".content .slot_asset").html("Drop Asset here!");
    $(this).parent().parent().find(".name a").remove();
    $(this).parent().parent().find(".name .drop_asset").remove();
    $('#edit_warning').css('visibility','visible');
	});	
	$(".preview_markup").click(function(){
    if ($(this).parent().parent().find(".content textarea").is(":visible")){
      $(this).parent().parent().find(".content textarea").hide();
      var markup = $(this).parent().parent().find(".content textarea").val();
      $(this).parent().parent().find(".content .preview").load("/markup/preview",{markup: markup});
      $(this).parent().parent().find(".content .preview").show();
    } else {
      $(this).parent().parent().find(".content .preview").hide();
      $(this).parent().parent().find(".content textarea").show();
    }
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
  $(".sortable_tray .asset").draggable(drag_opts_tray);
  $(".slot_asset .asset").draggable(drag_opts);
  $(".edit_slide select").change(function(){
    $('#edit_warning').css('visibility','visible');
  });
	$(window).keydown(function(event){
		switch(event.keyCode) {
		case 72: // h
      activeObj = document.activeElement;
      if (activeObj.type == "textarea") break;
      if ($("#editorhelp").is(":visible")) {
			  $("#editorhelp").css('visibility','hidden');
      } else {
        $("#editorhelp").css('visibility','visible');
      }
			break;
		}
		console.log(event.keyCode);
	});
});
