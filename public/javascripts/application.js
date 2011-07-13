// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
  $('.sortable').sortable({
    items: 'li',
    update: function(){
      $.ajax({
        type: 'post', 
        data: $('.sortable').sortable('serialize') + '&presentation_id = '+ $('.sortable').attr('id'), 
        dataType: 'script', 
        complete: function(request){
        $('.slide').effect('highlight');
        },
        url: "/" + $('.sortable').attr('id').replace(/\./g,"/")})
    }
  });
  $('.handle').draggable();
  $('.slot_asset').droppable();
});
