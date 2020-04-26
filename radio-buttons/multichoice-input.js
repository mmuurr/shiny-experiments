if(window.netrivia === undefined) {
    window.netrivia = {};
}

netrivia.multichoice_input_binding = new Shiny.InputBinding();
$.extend(netrivia.multichoice_input_binding, {
    find: function(scope) {
	return $(scope).find('.multichoice-input-container');
    },
    getValue: function(el) {
	// in shiny input_binding_radio.js, why is the selector not starting with $(el).find?
	return $('input:radio[name="' + Shiny.$escape(el.id) + '"]:checked').val();
    },
    subscribe: function(el, callback) {
	$(el).on('change.netrivia__multichoice_input_binding', function(event) {
	    callback();
	});
    },
    unsubscribe: function(el) {
	$(el).off('.netrivia__multichoice_input_binding');
    }
});

Shiny.inputBindings.register(netrivia.multichoice_input_binding);
