$(document).ready(function(){
  $("#fancybox-content .presentation_copy_button").live("click",function(event){
        event.preventDefault();
        $.fancybox.showActivity();
        var f_width = $(window).width()*0.8;
        var f_height = $(window).height()*0.8;
        var content_id = $(event.target).attr("content_id");
        $.post("/presentations/copy/"+content_id, function(retdata){
          $.fancybox({
            content: retdata,
            padding: 0,
            autoDimensions: false,
            width: f_width,
            height: f_height,
            onComplete: function(){$("#fancybox-content").attr("box_type","edit_asset");}
          });
        });
        reload_tray();
        $.fancybox.resize();
        $.fancybox.hideActivity();
  });
  $("#fancybox-content .markup_button").live("click",function(event){
    if ($("#markup_button").length > 0){
      event.preventDefault();
      $("#markup_button").click();
    }
  });
  if ($("#slots_wysiwyg").length > 0){
    $(".wysiwyg_button").hide();
  }
  $("#fancybox-content .asset_submit_button").live("click",function(event){
    event.preventDefault();
    $.fancybox.showActivity();
    var asset_type = $(event.target).attr("asset_type");
    var asset_id = $(event.target).attr("asset_id");
    if (asset_type == "FassetsPresentations::Presentation"){
      var p_title = $("#fancybox-content #presentation_title").val();
      var p_template = $("#fancybox-content #presentation_template").val();
      var data = {asset: {name: $("#fancybox-content #asset_name").val()}, presentation: {title: p_title, template: p_template}, "asset_id": asset_id};
      $.post("/presentations/"+asset_id, data, function(retdata){
        reload_tray();
        $.fancybox.close();
      });   
    }; 
  });
  var reload_tray = function() {
    var user_id = $("#tray").attr("user_id");
    $("#tray").load("/users/"+user_id+"/tray_positions/", function() {
      $('#tray .drop_button').click(function(event){
        event.preventDefault();
        var user_id = $(event.target).attr("user_id");
        var tp_id = $(event.target).attr("tp_id");
        $.ajax({
          type: 'DELETE',
          cache	: false,
          url		: "/users/"+user_id+"/tray_positions/"+tp_id,
          success: function(data) {
            $("#tray").load("/users/"+user_id+"/tray_positions/");
          }
        });
      });
    });
  };
});
