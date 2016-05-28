//= require jquery
//= require jquery_ujs
//= require "bootstrap.min"
//= require "jquery-ui-1.10.2.custom.min"
//= require jquery_nested_form
//= require rssaude


function format_dw_table_label(str){
	var html = "";
	if(str != ""){
		var items = str.replace("[","").replace("]","").split(".");
		html += "<b>"+items[0]+"</b>";
		$.each(items.splice(1),function(i,elem){
			html += " - <em>"+elem.replace("[","").replace("]","")+"</em> ";
		});
	}
	return html;
}

function format_dw_table(){
	$.each($(".table-wrapper tr th"),function(i,elem){
		$(elem).html(format_dw_table_label($(elem).html()));
	});
}