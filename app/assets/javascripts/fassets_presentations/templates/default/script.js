var Frame = {
  layout: function() {
    //          console.log("layout");
    var size = frame.height() / 50;
    $("body").css("font-size", size + 'px');
    $(".menu_header").css("height", (frame.height()/10)-40);
    $(".frame").css("width", frame.width()+20 + 'px');
    $(".frame").css("height", frame.height() + 'px');
    $(".header").css("width", frame.width()+20 + 'px')
    $("#" + Presentation.getframeIndex() + " .fit").each(function() {
      if (!$(this).data('dimensions')) {
        $(this).data('dimensions', {
          width: $(this).width(),
          height: $(this).height(),
          parent: $(this).offsetParent()
        });
      }
      var width = $(this).data('dimensions').width;
      var height = $(this).data('dimensions').height;

      var ratio = width/height;
      var parent = $(this).data('dimensions').parent;
      var new_width = 0;
      var new_height = 0;

      if (ratio < (parent.width() / parent.height())) {
        new_height = parent.height();
        new_width = new_height * ratio;
      } else {
        new_width = parent.width();
        new_height = new_width / ratio;
      }
      $(this).width(new_width);
      $(this).height(new_height);
    });

    //Align centered elements
    $(".center").each(function() {
      Slot.center($(this));
    });
    $(".center_v").each(function() {
      Slot.centerVertically($(this));
    });
    $(".center_h").each(function() {
      Slot.centerHorizontally($(this));
    });
  }
}

$(window).ready(function(){
  Frame.layout();
});
$(window).resize(function(){
  Frame.layout();
});

function toggleNavigationMenu() {
  if ($(".frame_menu").is(":visible")){
    $(".menu").hide("slow", function () {
      Frame.layout();
    });
  } else {
    $(".menu").show("slow", function () {Frame.layout();});
  }
}
