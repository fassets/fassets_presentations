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
});
