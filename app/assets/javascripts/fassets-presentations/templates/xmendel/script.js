function toggleNavigationMenu() {
  if ($(".nav").is(":visible")){
    $(".nav").hide("slow");
    $(".frame").css('padding-right', '0px');
  } else {
    $(".nav").show("slow");
    $(".frame").css('padding-right', '250px');
  }
}
