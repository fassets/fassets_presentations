$(document).ready(function(){
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
});