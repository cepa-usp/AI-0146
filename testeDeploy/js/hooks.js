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
	
	// Seta o número de frames
	N_FRAMES = 10;
  
	// Botão "avançar"
	$("#step-backward").button().click(stepBackwardOrNot);
	$("#step-forward").button().click(stepForwardOrFinish);

	// Tecla "enter" (também avança)
	$(":input").keypress(function (event) {
		if (event.which == 13) stepForwardOrFinish();
	});
	
	// Botão "reset"
	$("#reset").button({disabled: true}).click(function () {
		$("#reset-dialog").dialog("open");
	});

	// Configura as caixa de diálogo do botão "reset".
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

	// Configura as caixa de diálogo de seleção dos animais (imagens).
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

/*
 * Before set-frame hook.
 */
function preSetFrameHook (targetFrame) {
	return true;
}

/*
 * After set-frame hook.
 */
function postSetFrameHook (targetFrame) {

	memento.frame = targetFrame;
	
	// Configura os botões "avançar" e "recomeçar"
	var allow_reset = memento.completed && memento.frame > 0;
	$("#reset").button({disabled: !allow_reset});
	$("#step-forward").button({disabled: (memento.frame == N_FRAMES && memento.completed)});
  
	// Configuração específica de cada quadro
	switch (frame) {
		// 0 --> 1
		case  1:
		  break;
		  
		// 1 --> 2
		case  2:
		  break;
		  
		// 2 --> 3
		case  3:
		  break;
		  
		// 3 --> 4
		case  4:
		  break;

		// 4 --> 5
		case  5:
			break;
		  
		// 5 --> 6
		case  6:
		  break;
		  
		// 6 --> 7
		case  7:
		  break;

		// 7 --> 8
		case  8:
		  break;
		  
		// 8 --> 9
		case  9:
		  break;
		  
		// 9 --> 10
		case 10:
		  break;
		  
		default:
		  break;
	}
}

/**
 * This hook runs when the pre-set-frame hook returns false.
 */
function refusedSetFrameHook (targetFrame) {
}

/*
 * Before step-forward hook. If it returns false, step-foward will not be executed.
 */
function preStepForwardHook () {
  
  var proceed = false;
  
  //proceed = preStepFunctions[frame]("frame-"+frame);
  proceed = true;
  
  return proceed;
}

/*
 * After step-forward hook.
 */
function postStepForwardHook () {

	memento.frame = frame;
  
	var allow_reset = memento.completed && memento.frame > 0;
	$("#reset").button({disabled: !allow_reset});
	
	postStepFunctions[frame];
	
	commit(memento);
}

/*
 * Step-forward failure hook. It runs after "preStepForwardHook()" returns false
 */
function refusedStepForwardHook () {
}

/*
 * Before step-backward hook. If it returns false, step-backward will not be executed.
 */
function preStepBackwardHook () {
	return true;
}

/*
 * After step-backward hook.
 */
function postStepBackwardHook () {
}

/*
 * Step-backward failure hook. It runs after "preStepBackwardHook()" returns false
 */
function refusedStepBackwardHook () {
}

/*
 * Finish this AI
 */
function finish () {
	
	$(".completion-message").show();
	$("#score").html(memento.count);
	$("#finish-dialog").dialog("open");
	$("#step-forward").button({disabled: true});
	$("#reset").button({disabled: false});
	
	if (!memento.completed) {
		memento.completed = true;
		//memento.score = Math.max(0, Math.min(Math.ceil(100 * memento.count / memento.answers.length), 100));
		commit(memento);
	}
}

/*
 * Move forward, stepping to the next frame or finishing this AI
 */
function stepForwardOrFinish () {
	if (memento.frame < N_FRAMES) stepForward();
	else finish();
}

function stepBackwardOrNot () {
	if (memento.frame > 0) stepBackward();
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