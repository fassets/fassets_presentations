$(function(){
	$("#assets .asset").draggable({
		helper: 'clone', 
		connectToSortable: "#tray",
		start:function(e, ui) {
			$('#tray').addClass("active");
		}, 
		stop:function(e, ui) {
			$('#tray').removeClass("active");
		}
	});
});
