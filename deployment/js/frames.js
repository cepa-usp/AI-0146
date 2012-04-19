
function texto0_enterFrame(){
	
}
function texto0_leaveFrame(){
	//alert("saiu do primeiro")
}

/*------------------------------------------------------------------------------------------------*/

function interacao1_enterFrame(){
	movie.changeFuntion(1);
	movie.setX0(2);
	movie.setEpsilon(3);
	movie.lockX0(true);
	movie.lockEpsilon(true);
	movie.lockL(false);
	movie.lockDelta(false);
}
function interacao1_leaveFrame(){
	//commit(memento);
}

/*------------------------------------------------------------------------------------------------*/

function interacao2_enterFrame(){
	if(Math.abs(movie.getL() - 20) > 2) movie.setL(20);
	if(Math.abs(movie.getDelta() - 1) > 0.1) movie.setDelta(1);
}
function interacao2_leaveFrame(){
	//commit(memento);
}

/*------------------------------------------------------------------------------------------------*/

function interacao3_enterFrame(){
	movie.setDelta(0.2);
}
function interacao3_leaveFrame(){
	//commit(memento);
}

/*------------------------------------------------------------------------------------------------*/

function interacao4_enterFrame(){
	movie.setEpsilon(1);
}
function interacao4_leaveFrame(){
	//commit(memento);
}

/*------------------------------------------------------------------------------------------------*/

function interacao5_enterFrame(){
	movie.setEpsilon(0.5);
	if(movie.getDelta() > 0.05) movie.setDelta(0.05);
}
function interacao5_leaveFrame(){
	//commit(memento);
}

/*------------------------------------------------------------------------------------------------*/

function interacao6_enterFrame(){
	movie.changeFuntion(1);
	
	$("#wrongAnswer").hide();
	$("#rightAnswer").hide();
	$("#responder1").button().click(responde1);
	if(movie.getDelta() > 0.05) movie.setDelta(0.05);
	
	$("#entrada1").val(memento.respondidos["entrada1"]);
	
	if($("#entrada1").val() == ""){
		setForwardButtonEnabled(false);
	}else{
		setInputEnabled("entrada1", false);
		$("#entrada1").attr('disabled', 'disabled');
		$("#responder1").button({disabled: true});
		if(checkAnswer(5, parseFloat($("#entrada1").val().replace(",", ".")), TOLERANCE)){
			$("#rightAnswer").show();
		}else{
			$("#wrongAnswer").show();
		}
	}
}

function responde1(){
	if($("#entrada1").val() == ""){
		alert("Você precisa responder para continuar.");
	}else{
		if(validateAnswer("#entrada1")){
			setInputEnabled("entrada1", false);
			$("#responder1").button({disabled: true});
			memento.respondidos["entrada1"] = $("#entrada1").val();
			if(checkAnswer(5, parseFloat($("#entrada1").val().replace(",", ".")), TOLERANCE)){
				$("#rightAnswer").show();
			}else{
				$("#wrongAnswer").show();
			}
			setForwardButtonEnabled(true);
			commit(memento);
		}else{
			alert("Digite um número válido.");
		}
	}
}

function validateAnswer (selector) {
  var value = $(selector).val().replace(",", ".");
  var isValid = !isNaN(value) && value != "";
  if (!isValid) $(selector).val("");
  return isValid;
}

function interacao6_leaveFrame(){
	//commit(memento);
}

/*------------------------------------------------------------------------------------------------*/

function interacao7_enterFrame(){
	movie.changeFuntion(1);
	movie.setX0(3);
	movie.setDelta(1);
	movie.setEpsilon(3);
	//movie.setZoom(1);
}
function interacao7_leaveFrame(){
	//commit(memento);
}

/*------------------------------------------------------------------------------------------------*/

