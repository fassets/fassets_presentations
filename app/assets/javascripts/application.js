// Place your application-specific JavaScript functions and classes here
//
//= require jquery
//= require jquery_ujs
//= require dombuilder
//= require jquery-ui
//= require jquery.ui.nestedSortable
//= require jquery.collapsiblePanel-0.2.0
//= require jquery.myimgscale-0.2
//= require jquery.fancyzoom
//= require_self
//= require_tree .
//
$(document).ready(function(){
	$('.sortable_frames').nestedSortable({
		disableNesting: 'no-nest',
		forcePlaceholderSize: true,
		handle: 'div',
		helper:	'clone',
		items: 'li',
		maxLevels: 5,
		opacity: .6,
		placeholder: 'placeholder',
		revert: 250,
		tabSize: 35,
		tolerance: 'pointer',
		toleranceElement: '> div',
    update: function(ev,ui){
      $.ajax({
        type: 'post',
        data: "frame="+JSON.stringify($(".sortable_frames").nestedSortable('toArray')),
        dataType: 'json',
        complete: function(request){
        $('.frame').effect('highlight',{},2000);
        },
        url: "/" + $('#frames').attr('path').replace(/\./g,"/")})
    }
	}),
  $('#tray ol').sortable({
    items: 'li',
    connectWith: "ul",
    update: function(ev, ui){
      $.ajax({
        type: 'put',
        data: $('.sortable_tray').sortable('serialize')+"&asset_id="+$(ui.item).attr("asset_id"),
        dataType: 'script',
        complete: function(request){
          window.location.reload();
          $('#tray').effect('highlight',{},2000);
        },
        url: "/" + $('.sortable_tray').attr('id').replace(/\./g,"/")})
    },
  });
  $('ul #assets').draggable({
    items: 'li',
    connectToSortable: "#tray ol",
    helper: "clone",
  });
  $("#catalog_main").droppable({
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
    $.ajax({
      type: 'put',
      url: window.location.href + "/add_asset",
      data: "&asset_id="+id,
    });
    window.location.reload();
    }
  });
  $(".collapsable_label").collapsiblePanel({
    collapsedImage: "/assets/collapsed.png",
    expandedImage: "/assets/collapse.png",
    titleQuery: ".labeltitle",
    startCollapsed: true
  });
  $(".collapsable_facetlabels").collapsiblePanel({
    collapsedImage: "/assets/collapsed.png",
    expandedImage: "/assets/collapse.png",
    titleQuery: ".facetlabelstitle",
    startCollapsed: true
  });
  $(".collapsable_facet").collapsiblePanel({
    collapsedImage: "/assets/collapsed.png",
    expandedImage: "/assets/collapse.png",
    titleQuery: ".facettitle",
    startCollapsed: true
  });
  $(".collapsable_frame").collapsiblePanel({
    collapsedImage: "/assets/collapsed.png",
    expandedImage: "/assets/collapse.png",
    titleQuery: ".frametitle",
    startCollapsed: true
  })
  $(".collapsable_topic").collapsiblePanel({
    collapsedImage: "/assets/collapsed.png",
    expandedImage: "/assets/collapse.png",
    titleQuery: ".topictitle",
    startCollapsed: true
  })
  $(".collapsable_catalog").collapsiblePanel({
    collapsedImage: "/assets/collapsed.png",
    expandedImage: "/assets/collapse.png",
    titleQuery: ".catalogtitle",
    startCollapsed: true
  })
  $(".collapsable_classification").collapsiblePanel({
    collapsedImage: "/assets/collapsed.png",
    expandedImage: "/assets/collapse.png",
    titleQuery: ".classificationtitle",
    startCollapsed: true
  })
  $(".collapsable_classificationfacet").collapsiblePanel({
    collapsedImage: "/assets/collapsed.png",
    expandedImage: "/assets/collapse.png",
    titleQuery: ".classificationfacettitle",
    startCollapsed: true
  })
//    $(".content .preview").css("font-size", $(window).height()/32 + 'px');
//  });
  $('form[class$="_asset"] input[name="commit"], form[class$="_presentation"] input[name="commit"], form[class$="_url"] input[name="commit"]').click(function (event){
    if ($("#asset_name").val() == "") {
      $("#name_warning").text("Name cannot be empty!");
      event.preventDefault();
    }
    if ($("#file_asset_file").val() == ""){
      $("#file_warning").text("File cannot be empty!");
      event.preventDefault();
    }
    if ($("#presentation_title").val() == ""){
      $("#title_warning").text("Title cannot be empty!");
      event.preventDefault();
    }
    if ($("#url_url").val() == ""){
      $("#url_warning").text("Url cannot be empty!");
      event.preventDefault();
    }
  })
});
