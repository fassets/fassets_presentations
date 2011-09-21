var Slide = {
  width: function() {
    return $(window).width();
  },
  height: function() {
    return $(window).height();
  },
  syncSize: function() {
    var size = Frame.height() / 30;
    $("body").css("font-size", size + 'px');
    $(".frame").css("width", Frame.width() + 'px');
    $(".frame").css("height", Frame.height() + 'px');

    //Align vertically centered elements
    $(".center_vertically").each(function() {
      var pos = ($(this).parent().height() - $(this).height()) / 2;
      $(this).css("top", pos + "px");
    });
  }
}

$(window).ready(function(){
  Frame.syncSize();
});
$(window).resize(function(){
  console.log("resize event")
  Frame.syncSize();
});

functian toggleNavigationMenu() {
  if ($(".frame_menu").is(":visible")){
    $("#menu").hide("slow", function () {
      frame.layout();
    });
  } else {
    $("#menu").show("slow", function () {frame.layout();});
  }
}
