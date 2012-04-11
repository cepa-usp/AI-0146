
function texto0_enterFrame(){
	//alert("oieeee");
}
function texto0_leaveFrame(){
	//alert("saiu do primeiro")
}

/*------------------------------------------------------------------------------------------------*/

function texto1_enterFrame(){
	movie.setX0(2);
	movie.setEpsilon(3);
	movie.lockX0(true);
	movie.lockEpsilon(true);
	movie.lockL(false);
	movie.lockDelta(false);
}
function texto1_leaveFrame(){
	if(Math.abs(Math.abs(movie.getL()) - 20) > 2) movie.setL(20);
	if(Math.abs(Math.abs(movie.getDelta()) - 1) > 0.1) movie.setDelta(1);
}

/*------------------------------------------------------------------------------------------------*/

function outrotexto_enterFrame(){
	movie.setDelta(0.2);
}
function outrotexto_leaveFrame(){
	//alert("saiu outro");
}

/*------------------------------------------------------------------------------------------------*/

function outrotexto2_enterFrame(){
	movie.setEpsilon(1);
}
function outrotexto2_leaveFrame(){
	//alert("saiu outro");
}

/*------------------------------------------------------------------------------------------------*/

function outrotexto3_enterFrame(){
	movie.setEpsilon(0.5);
}
function outrotexto3_leaveFrame(){
	//alert("saiu outro");
}

/*------------------------------------------------------------------------------------------------*/

function outrotexto4_enterFrame(){
	if(movie.getDelta() > 0.05) movie.setDelta(0.05);
}
function outrotexto4_leaveFrame(){
	//alert("saiu outro");
}

/*------------------------------------------------------------------------------------------------*/
