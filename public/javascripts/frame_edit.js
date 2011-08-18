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
    if ($(ui.draggable).attr("rel") != "undefined") {
			id = $(ui.draggable).attr("rel");
			asset.find("input").remove();
			asset.attr("id", "asset_" + id);
		} else {
			id = $(ui.draggable).attr("id").split('_')[1];
		}
		$(this).find(".content input").val(id);
		$(this).find(".content textarea").hide();
    $(this).find(".content .preview").hide();
		$(this).find(".name select").val("asset");
    $(this).find(".name .preview_markup").hide();
    $(this).find(".content .slot_asset").load('/assets/'+id+'/preview', function(){
      resize_slots();
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
    $(this).find(".content .slot_asset").show()
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
//      $(this).parent().parent().find(".content .preview").css("font-size", $(window).height()/32 + 'px');
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
    var preview_button = $(this).parent().find(".preview_markup");
    preview_button_link = '<img width="15" height="15" title="Preview" src="/images/markup_preview.png?1312392304" onmouseover="this.style.cursor = pointer" class="preview_markup" alt="Preview" style="cursor: pointer;">'
		if ($(this).val() == "markup") {
			asset.hide();
      if (preview_button.length){
        preview_button.show();
      } else {
        $(this).parent().append(preview_button_link);
      }
			text.show();
		} else {
      preview_button.hide();
			asset.show();
			text.hide();
		}
	});
  $(".sortable_tray .asset").draggable(drag_opts_tray);
  $(".slot_asset .asset").draggable(drag_opts);
  $(".edit_frame select").change(function(){
    $('#edit_warning').css('visibility','visible');
  });
  var resize_slots = function(){
    height = $(window).height();
    width = $(window).width();
    $("#slot_top").css("height", height*0.4 + 'px');
    $("#slot_top").css("width", width*0.7 + 'px');
    $("#slot_bottom").css("height", height*0.4 + 'px');
    $("#slot_bottom").css("width", width*0.7 + 'px');
    $("#slot_topleft").css("height", height*0.4 + 'px');
    $("#slot_topleft").css("width", width*0.33 + 'px');
    $("#slot_topright").css("height", height*0.4 + 'px');
    $("#slot_topright").css("width", width*0.33 + 'px');
    $("#slot_left").css("height", height*0.8 + 'px');
    $("#slot_left").css("width", width*0.33 + 'px');
    $("#slot_right").css("height", height*0.8 + 'px');
    $("#slot_right").css("width", width*0.33 + 'px');
    $("#slot_center").css("height", height*0.8 + 'px');
    $("#slot_center").css("width", width*0.66 + 'px');
    $("#slot_subtitle").css("height", height*0.4 + 'px');
    $("#slot_subtitle").css("width", width*0.66 + 'px');
    $("#slot_centertitle").css("height", height*0.4 + 'px');
    $("#slot_centertitle").css("width", width*0.66 + 'px');
    $("img.fit").scaleImage({
      parent: "li",
      scale: 'fit',
      center: true
    });
  }
  resize_slots();
  $(window).resize(function() {resize_slots()});
	$(window).keydown(function(event){
		switch(event.keyCode) {
		case 72: // h
      activeObj = document.activeElement;
      if (activeObj.type == "textarea") break;
      if (activeObj.type == "text") break;
      if ($("#editorhelp").is(":visible")) {
			  $("#editorhelp").css('visibility','hidden');
      } else {
        $("#editorhelp").css('visibility','visible');
      }
			break;
    case 83: // s
      if (event.ctrlKey){
        event.preventDefault();
        document.forms["edit_frame"].submit();
      }
      break;
		}
		console.log(event.keyCode);
	});
});
