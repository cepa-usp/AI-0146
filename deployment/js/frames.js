
function texto0_enterFrame(){
	//alert("oieeee");
}
function texto0_leaveFrame(){
	//alert("saiu do primeiro")
}

/*------------------------------------------------------------------------------------------------*/

function interacao1_enterFrame(){
	alert("entrou");
	movie.setX0(2);
	movie.setEpsilon(3);
	movie.lockX0(true);
	movie.lockEpsilon(true);
	movie.lockL(false);
	movie.lockDelta(false);
}
function interacao1_leaveFrame(){
	
}

/*------------------------------------------------------------------------------------------------*/

function interacao2_enterFrame(){
	if(Math.abs(Math.abs(movie.getL()) - 20) > 2) movie.setL(20);
	if(Math.abs(Math.abs(movie.getDelta()) - 1) > 0.1) movie.setDelta(1);
}
function interacao2_leaveFrame(){
	//alert("saiu outro");
}

/*------------------------------------------------------------------------------------------------*/

function interacao3_enterFrame(){
	movie.setDelta(0.2);
}
function interacao3_leaveFrame(){
	//alert("saiu outro");
}

/*------------------------------------------------------------------------------------------------*/

function interacao4_enterFrame(){
	movie.setEpsilon(1);
}
function interacao4_leaveFrame(){
	//alert("saiu outro");
}

/*------------------------------------------------------------------------------------------------*/

function interacao5_enterFrame(){
	movie.setEpsilon(0.5);
	if(movie.getDelta() > 0.05) movie.setDelta(0.05);
}
function interacao5_leaveFrame(){
	//alert("saiu outro");
}

/*------------------------------------------------------------------------------------------------*/

function interacao6_enterFrame(){
	if(movie.getDelta() > 0.05) movie.setDelta(0.05);
}
function interacao6_leaveFrame(){
	//alert("saiu outro");
}

/*------------------------------------------------------------------------------------------------*/

