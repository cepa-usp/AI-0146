// Current frame
var frame = 0;
var content;

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
			setFrame(next_frame);
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
			setFrame(next_frame);
		}
		else {
			refusedStepBackwardHook();
		}
	}
}

/*
 * Sets current frame to <targetFrame>
 */
function setFrame(targetFrame) {
 
	if (!isNaN(targetFrame) && targetFrame >= 0 && targetFrame <= N_FRAMES) { 
		if (preSetFrameHook(targetFrame)) {
			if(frame!=targetFrame){
				var oldContentElement = content[frame].id;
				callLeaveFrame(oldContentElement);
			}
			
			var contentElement = content[targetFrame].id;
			callEnterFrame(contentElement);
			
			var htmlContent = $(content[targetFrame]).html();
			$('#textArea').html(htmlContent);

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