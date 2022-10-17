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
    },
    receiveMessage: function(el, data) {
	console.log(data);
	if(data.hasOwnProperty('set_icon')) {
	    let radio_choice_icons = $(el).find('span.radio-choice-icon');
	    radio_choice_icons.empty(); // clears any existing icons
	    radio_choice_icons.
		eq(data.set_icon.ix1 - 1).
		html(data.set_icon.html);
	}
	if(data.hasOwnProperty('set_pct')) {
	    let radio_choice_tile_fills = $(el).find('div.radio-choice-tile-fill');
	    radio_choice_tile_fills.each(function(ix0, el) {
		$(el).css('width', data.set_pct[ix0] + '%');
	    });
	}
	if(data.hasOwnProperty('set_answer')) {
	    let radio_choice_containers = $(el).find('div.radio-choice-container');
	    radio_choice_containers.each(function(ix0, el) {
		$(el).attr('data-answer', data.set_answer[ix0]);
	    });
	}
    }
});

 // relies on event bubbling so the container handles an input change event.
// $('input.radio-choice-tile-input').on('change', function(event) {
//     console.log("change");
//     //let radio_choice_container = this.closest('.radio-choice-container');
//     //radio_choice_container.siblings().removeAttr('data-answer')
//     //radio_choice_container.attr('data-answer', 'selected');
// });

$(document).ready(function() {

    // delegated handler hooked onto document.body because the question modules will come-and-go via renderUI.
    // this also relies on event-bubbling from the input 'change' event up through the DOM.
    $(document.body).on('change', 'div.radio-choice-container', null, function(event) {
	$(this).siblings().removeAttr('data-answer');
	$(this).attr('data-answer', 'selected');
	event.stopPropagation();
	event.stopImmediatePropagation();
    });

});

Shiny.inputBindings.register(netrivia.multichoice_input_binding);


// {
//     set_icon: { html: "<icon>", ix1: 4 },
//     set_pct: [ 10.0, 20.0, 30.0, 40.0 ],
//     set_answer: [ "incorrect", "correct", "incorrect", "incorrect", "skip" ]
// }
