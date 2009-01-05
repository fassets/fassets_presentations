// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ajaxSend(function(event, request, settings) {
  if (typeof(AUTH_TOKEN) == "undefined") return;
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

function noEventPropagation(event){
	alert("stops");
	return false;
}
function ajaxifyTrayRemoveButtons() {
	$('#tray form.button-to').submit(function() { 
        $(this).ajaxSubmit({dataType:'script'}); 
 		return false;
    });
}


function updateTray() {
	var asset = $("#tray .asset[id^=asset]");
	if (asset.length == 1) {
		var asset_id = asset.attr("id").split("_")[1];
		asset.attr("id", "tray_0");
	}
	$.ajax({
		data:$("#tray").sortable('serialize') + '&_method=put' + (asset_id ? "&add_asset=" + asset_id : ""),	
		dataType:'script',	
		type:'post', url:'/users/' + CURRENT_USER + '/tray_positions/sort'
	});
	
}
$(function(){
	//Fancy Image Zooming
	$.fn.fancyzoom.defaultsOptions.imgDir='/images/fancyzoom/';
	$('a.zoom').fancyzoom();
	$('a.thumbnail').fancyzoom();
	
	//Fold Drawers
	$('ul.drawers .handle').click(function() {
		$(this).toggleClass('active');
		if ($(this).hasClass('active')) {
			$(this).find("input").val(1);
 		} else {
			$(this).find("input").val(0);
		}
		$(this).next().slideToggle('normal');
	}).not('.active').next().hide();
	
	$('a.form_toggle').click(function() {
		$(this).parent().next().slideToggle('normal');
		return false;
	}).parent().next().hide();	
	
	//Tray sortable
	$('#tray').sortable({
		dropOnEmpty: true,
		placeholder:'asset_placeholder',
		helper: "",
		items: ".asset",
		update:function(e, ui){
			console.log("update " + ui.placeholder);
			updateTray();
		},
		receive:function(e, ui) {
			console.log("receive " + ui.placeholder);
		}
	});
	
	ajaxifyTrayRemoveButtons();
		
	$('#catalog_selector').change(function() {
		window.location = "http://" + HOST + "/catalogs/" + this.value;
	});
});


