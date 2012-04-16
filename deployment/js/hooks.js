/*
 * Before fetch hook (executes setup that are independent of AI status).
 */
function preFetchHook () {
	
	$(".init-message").show();
	
	// Insere o filme Flash na página HTML
	$("#ai-container").flash({
		swf: "swf/AI-0146.swf",
		width: 600,
		height: 600,
		play: false,
		id: "ai",
		allowScriptAccess: "always",
		flashvars: {},
		expressInstaller: "swf/expressInstall.swf",
	});

	// Referência para o filme Flash. 
	movie = $("#ai")[0];
}

function configButtons () {
	$("#step-backward").button().click(onButtonBackward);
	$("#step-forward").button().click(onButtonForward);
	$(":input").keypress(function (event) {
		if (event.which == 13) onButtonForward();
	});

	// reset
	$("#reset").button({disabled: true}).click(function () {
		$("#reset-dialog").dialog("open");
	});
	$("#reset-dialog").dialog({
		buttons: {
			"Ok": function () {
				$(this).dialog("close");
				reset();
			},
			"Cancelar": function () {
				$(this).dialog("close");
			}
		},
		autoOpen: false,
		modal: true,
		width: 350
	});
	
	$("#finish-dialog").dialog({
		buttons: {
			"Ok": function () {
				$(this).dialog("close");
			}
		},
		autoOpen: false,
		modal: true,
		width: 500
	});	
}

/*
 * After fetch hook (executes setup that are dependent of AI status).
 */
function postFetchHook (state) {

	// Adiciona o nome do usuário
	if (state.learner != "") {
		var prename = state.learner.split(",")[1];
		$("#learner-prename").html(prename + ",");
	}

	if (memento.completed) $(".completion-message").show();
	else $(".completion-message").hide();
	
	// Espera os callbacks do filme Flash ficarem disponíveis
	t1 = new Date().getTime();
	checkCallbacks();
}
function onButtonForward () {
	if (memento.frame < N_FRAMES - 1) {
		stepForward();
	}
	else {
		finish();
	}
}

function onButtonBackward () {
	if (memento.frame > 0) {
		stepBackward();
	}
}

function finish () {
	
	$(".completion-message").show();
	$("#score").html(memento.count);
	$("#finish-dialog").dialog("open");
	$("#step-forward").button({disabled: true});
	$("#reset").button({disabled: false});
	
	if (!memento.completed) {
		memento.completed = true;
		memento.score = 100;//Math.max(0, Math.min(Math.ceil(100 * memento.count / memento.answers.length), 100));
		commit(memento);
	}
}

function setBackwardButtonEnabled(booleanValue){
	$("#step-backward").button({disabled: !booleanValue});
}

// Checks if given selector (type input) is a valid number. If not, resets field.
function validateAnswer (selector) {
  var value = $(selector).val().replace(",", ".");
  var isValid = !isNaN(value) && value != "";
  if (!isValid) $(selector).val("");
  return isValid;
}

// Check given answer against expected one, with relative tolerance also given
function checkAnswer (correct_answer, user_answer, tolerance) {
  return Math.abs(correct_answer - user_answer) < correct_answer * tolerance;
}

// Format a given number with 2 decimal places, and substitute period by comma.
function formatNumber (string) {
	return new Number(string).toFixed(2).replace(".", ",");
}