$(function(){
  $("#assets li.asset").draggable({
    handle: ".handle",
    helper: "clone",
    connectToSortable: "#tray ol",
    start:function(e, ui) {
      $('#tray ol').addClass("active");
    },
    stop:function(e, ui) {
      $('#tray ol').removeClass("active");
    }
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
        id = $(ui.draggable).attr("asset_id");
      }
      $.ajax({
        type: 'put',
        url: window.location.href + "/add_asset",
        data: "&asset_id="+id,
      });
      window.location.reload();
    }
  });
});
