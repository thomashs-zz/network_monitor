// custom rs autocomplete
(function( $ ){
	$.fn.rs_autocomplete = function(options){
		// pode ser employees, employee_companies, companies, employee_and_companies
		var default_ = { type : "employees" } 
		var settings = $.extend(default_,options);
		var url = "/ws/ac.json?type=" + settings["type"];
		// =======
		return this.keydown(function(e){
			if(e.keyCode == 46 || e.keyCode == 8)
				$(this).removeClass('alert-success');
		}).each(function(){
			// marcar com verde
			var current_val = (settings["hidden_id"] != null ? $("#"+settings["hidden_id"]).val() : $("#"+$(this).attr("hidden_id")).val());
			if(current_val != ""){ 
				$(this).addClass('alert-success');
				if(options["onClear"] != null) options["onClear"]();
			}
			// ---
			$(this).autocomplete({
				source : function(request,response){
					$.ajax({
						url: url,
						data: { term: request.term },
						success: function(data){
							response($.map(data,function(item){
								return {
									label : item.label,
									id : item.value
								}
							}));
						},
						error: function(jqXHR,textStatus,errorThrown){
							alert($.parseJSON(jqXHR.responseText)['error']);
							window.location = window.location;
						}
					});
				},
				minLength : 3,
				select : function(event,ui){
					$(this).val(ui.item.label);
					if(settings["callback"] != null) 
						settings["callback"](event,ui);
					//--
					if(settings["hidden_id"] != null) 
						$("#"+settings["hidden_id"]).val(ui.item.id);
					else
						$("#"+$(this).attr("hidden_id")).val(ui.item.id);
					// CSS
					$(this).addClass('alert-success');
					return false;
				}
			});
		});
	};
})(jQuery);
// ================================================


/*
* Ajax overlay 1.0
* Author: Simon Ilett @ aplusdesign.com.au
* Descrip: Creates and inserts an ajax loader for ajax calls / timed events 
* Date: 03/08/2011 
*/
function ajaxLoader (el, options) {
	// Becomes this.options
	var defaults = {
		bgColor 		: '#fff',
		duration		: 800,
		opacity			: 0.7,
		classOveride 	: false
	}
	this.options 	= jQuery.extend(defaults, options);
	this.container 	= $(el);
	
	this.init = function() {
		var container = this.container;
		// Delete any other loaders
		this.remove(); 
		// Create the overlay 
		var overlay = $('<div></div>').css({
				'background-color': this.options.bgColor,
				'opacity':this.options.opacity,
				'width':container.width(),
				'height':container.height(),
				'position':'absolute',
				'top':'0px',
				'left':'0px',
				'z-index':99999
		}).addClass('ajax_overlay');
		// add an overiding class name to set new loader style 
		if (this.options.classOveride) {
			overlay.addClass(this.options.classOveride);
		}
		// insert overlay and loader into DOM 
		container.append(
			overlay.append(
				$('<div></div>').addClass('ajax_loader')
			).fadeIn(this.options.duration)
		);
    };
	this.remove = function(){
		var overlay = this.container.children(".ajax_overlay");
		if (overlay.length) {
			overlay.fadeOut(this.options.classOveride, function() {
				overlay.remove();
			});
		}	
	}
	this.init();
}	

Array.prototype.pushIfNotExist = function(element, comparer) { 
    if (!this.inArray(comparer)) {
        this.push(element);
    }
}; 


function adjust_heights(id_or_class){
	$(id_or_class).css("height","");
	var biggest = 0;
	$.each($(id_or_class),function(i,elem){
		var h = $(elem).height();
		if(h > biggest) biggest = h;
	});
	$(id_or_class).height(biggest);
}
