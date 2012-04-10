// Current frame
var frame = 0;

// Amount of frames
var N_FRAMES = 0;

/*
 * Step frame forward
 */
function stepForward () {

	var next_frame = frame + 1;

	if (next_frame <= N_FRAMES) {
		if (preStepForwardHook()) {

			message("Transição " + frame + " -> " + next_frame);
			
			document.getElementById("textArea").innerHTML = textos[next_frame];
			
			//$("#frame-" + frame).removeClass("current-frame");
			//$("#frame-" + next_frame).show().addClass("current-frame");

			frame = next_frame;

			postStepForwardHook();
		}
		else {
			refusedStepForwardHook();
		}
	}
}

/*
 * Step frame backward
 */
function stepBackward () {

	var next_frame = frame - 1;
  
	if (next_frame >= 0) {
		if (preStepBackwardHook()) {

			message("Transição " + frame + " -> " + next_frame);
			
			document.getElementById("textArea").innerHTML = textos[next_frame];

			//$("#frame-" + frame).hide().removeClass("current-frame");
			//$("#frame-" + next_frame).addClass("current-frame");

			frame = next_frame;

			postStepBackwardHook();
		}
		else {
			refusedStepBackwardHook();
		}
	}
}

/*
 * Sets current frame to <targetFrame>
 */
function setFrame (targetFrame) {
  
	if (!isNaN(targetFrame) && targetFrame >= 0 && targetFrame <= N_FRAMES) { 
		if (preSetFrameHook(targetFrame)) {

			$(".frame").removeClass("current-frame");
			$("#frame-" + targetFrame).addClass("current-frame");

			// TODO: não gostei desta solução. Há uma iteração para cada frame, e para cada uma delas há uma função rodando (map) sobre um vetor (result) de um elemento.
			for (var i = 0; i <= N_FRAMES; i++) {
				var result = $("#frame-" + i);
				$.map(result, (i > targetFrame ? hide : show));
			}

			frame = targetFrame;
			
			postSetFrameHook(targetFrame);
		}
		else {
			refusedSetFrameHook(targetFrame);
		}
	}
}

// Auxiliary function: counts the amount of frames
function countFrames () {
	return $(".frame").length - 1;
}

// Auxiliary function: shows a given <element>
function show (element) {
  $(element).show();
}

// Auxiliary function: hides a given <element>
function hide (element) {
  $(element).hide();
}