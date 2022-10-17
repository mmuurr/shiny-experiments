// step i
var binding = new Shiny.InputBinding();

// step ii
$.extend(binding, {
    
    find: function(scope) {
	let x = $(scope).find('.risio-test-input');
	console.log(x);
	return x;
    },

    initialize: function(el) {
	console.log(el);
	$(el).find('li').click(function() {
	    let selected_val = $(this).text();
	    $(el).find('button span').first().text(selected_val);
	});
    },

    getId: function(el) {
	console.log("getId");
	return $(el).data("inputId");
    },

    getValue: function(el) {
	let val = {
	    question_ix: $(el).data('risioQuestionIx'),
	    text: $(el).find('input[type=text]').val(),
	    dropdown: $(el).find('button span').first().text()
	};
	return val;
    },

    subscribe: function(el, callback) {
	console.log("subscribe");
	$(el).on('keyup.binding input.binding', 'input[type=text]', null, function(event) {
	    callback(true);
	});
	$(el).on('change.binding', 'input[type=text]', null, function(event) {
	    callback(false);
	});
    },

    unsubscribe: function(el) {
	$(el).off('.binding');
    },

    getRatePolicy: function() {
	return {
	    policy: 'debounce',
	    delay: 250
	};
    }
    
});

// step iii
Shiny.inputBindings.register(binding);
