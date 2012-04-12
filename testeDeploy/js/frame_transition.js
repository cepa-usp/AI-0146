

/*
 * Step frame forward
 */
function stepForward () {
	var next_frame = frame + 1;
	if (next_frame <= N_FRAMES) {
		setFrame(next_frame);
	}
}

/*
 * Step frame backward
 */
function stepBackward () {
	var next_frame = frame - 1;  
	if (next_frame >= 0) {
		setFrame(next_frame);
	}
}

/*
 * Sets current frame to <targetFrame>
 */
function setFrame(targetFrame) {
	if (!isNaN(targetFrame) && targetFrame >= 0 && targetFrame <= N_FRAMES) { 
			if(frame!=targetFrame && frame>=0){
				var oldContentElement = content[frame].id;
				callLeaveFrame(oldContentElement);
			}
			
			var contentElement = content[targetFrame].id;
			var htmlContent = $(content[targetFrame]).html();
			$('#textArea').html(htmlContent);

			
			callEnterFrame(contentElement);
			

			frame = targetFrame;	
			memento.frame = frame;
			//postSetFrameHook(targetFrame);
			
			if(frame == 0){
				setForwardButtonEnabled(true);
				setBackwardButtonEnabled(false);
				setResetButtonEnabled(false);
			}else if(frame == N_FRAMES - 1){
				setForwardButtonEnabled(false);
				setBackwardButtonEnabled(true);
				setResetButtonEnabled(true);
			}else{
				setForwardButtonEnabled(true);
				setBackwardButtonEnabled(true);
				setResetButtonEnabled(false);
			}
	}
}

function setForwardButtonEnabled(booleanValue){
	$("#step-forward").button({disabled: !booleanValue});
}

function setBackwardButtonEnabled(booleanValue){
	$("#step-backward").button({disabled: !booleanValue});
}

function setResetButtonEnabled(booleanValue){
	$("#reset").button({disabled: !booleanValue});
}

function setInputEnabled(textfieldId, booleanValue){
	if(!booleanValue){
		$("#" + textfieldId).attr('disabled', 'disabled');	
	} else {
		$("#" + textfieldId).removeAttr('disabled');
	}
}

// Auxiliary function: shows a given <element>
function show (element) {
  $(element).show();
}

// Auxiliary function: hides a given <element>
function hide (element) {
  $(element).hide();
}