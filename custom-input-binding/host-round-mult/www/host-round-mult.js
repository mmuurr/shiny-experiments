var hostRoundMultInputBinding = new Shiny.InputBinding();

$.extend(hostRoundMultInputBinding, {

	// shared across all bound DOM elements, since there's only one actual binding object.
	// so to keep client-side state, data is a map from element id to actual data.
	data: {},

	getData: function(el) {
		// return data[this.getId(el)] ?? null;  // possibly not supported in some browsers
		return this.data[this.getId(el)] || null;
	},

	setData: function(el, data) {
		this.data[this.getId(el)] = data;
	},

	registerBoundBeacon: function(el) {
		var inputId = this.getId(el) + "__ready";
		$(el).on("shiny:bound", function(event) {
			console.log("shiny:bound event on " + event.target);
			console.log(el.id + " " + inputId);
			//Shiny.setInputValue(inputId, Date.now());
		});
	},

	// sendReadyBeacon: function(el) {
	// 	$(
		
	// 	if (Shiny.shinyapp.isConnected()) {
	// 		console.log(inputId + " (immediate)");
	// 		Shiny.setInputValue(inputId, Date.now());
	// 	} else {
	// 		$(document).one("shiny:connected", null, inputId, function(e) {
	// 			console.log(inputId + " (shiny:connected)");
	// 			Shiny.setInputValue(e.data, Date.now());
	// 		});
	// 	}
	// },

	updateTable: function(el) {
		// table element:
		var elTableBody = $(el).find("table > tbody").first();
		
		// remove all rows except first:
		elTableBody.find("tr:gt(0)").remove();

		var data = this.getData(el);
		
		for (var i = 0; i < data.roundCount; i++) {
			var elTdLabel = $("<td></td>").text(data.roundLabels[i]);
			var elTdPlayerMult = $("<td></td>").text(data.playerMults[i]);
			var elTdHostMult =
				$("<input type='number' class='form-control' min='0' step='1'></input>")
				.val(data.hostMults[i])
				.data("roundIx0", i);
			var elTr = $("<tr></tr>").append(elTdLabel).append(elTdPlayerMult).append(elTdHostMult);
			elTableBody.append(elTr);
		}
	},

	// Shiny
	getType: function() {
		return "risio.livegame.hostRoundMultInputBinding";
	},
	
	// Shiny
	find: function(scope) {
		return $(scope).find(".risio-livegame-host-mult-input");
	},

	// Shiny
	initialize: function(el) {
		console.log("initialize[" + this.getId(el) + "]");
		this.setData(el, null);
		//this.registerBoundBeacon(el);
		//this.sendReadyBeacon(el);
	},

	// Shiny
	getValue: function(el) {
		var jsnow = Date.now();
		var data = this.getData(el);
		var value = JSON.stringify({ jsnow : "konstant" , data : data });
		console.log("getValue[" + this.getId(el) + "], value = " + value);
		return value;
	},

	// Shiny
	receiveMessage: function(el, msg) {
		this.setData(el, msg || {});
		this.updateTable(el);
	},

	// Shiny
	subscribe: function(el, callback) {
		$(el).on("change.hostRoundMultInputBinding", "input[type='number']", this, function(e) {
			var binding = e.data;
			var elInput = $(e.target);
			var roundIx0 = elInput.data("roundIx0");
			var newVal = parseFloat(elInput.val());
			if (newVal == 0) {
				newVal = NaN;
				elInput.val("");
			}
			binding.getData(el).hostMults[roundIx0] = newVal;
			callback(true);  // true == use debounce policy
		});
	},

	// Shiny
	unsubscribe: function(el) {
		$(el).off(".hostRoundMultInputBinding");
	}
	
});

Shiny.inputBindings.register(hostRoundMultInputBinding, "risio.livegame.hostRoundMultInputBinding");

