$(function(){
	//Sortable Labels
	$('#labels').sortable({
		axis: 'y',
		start: function() {
			$('#labels .handle').bind('click',noEventPropagation);
		}, 
		stop:function() {
			$('#labels .handle').unbind('click', noEventPropagation);
		},
		update:function(){
		}

	});
});

/*$.ajax({
	data:$(this).sortable('serialize') + '&_method=put',		
	type:'post', url:'/users/1/tray'
})*/
