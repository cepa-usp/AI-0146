var TOLERANCE = 0.1; // Tolerância nas respostas: 10%
var LOCAL_STORAGE_KEY = "AI-0146";
var MAX_INIT_TRIES = 60;
var init_tries = 0;
var scorm = pipwerks.SCORM; // Seção SCORM
scorm.version = "2004"; // Versão da API SCORM
var movie; // O filme Flash
var memento = {}; // Dados da AI
var session = {}; // Dados da sessão SCORM
var t1;
var debug = true;


$(document).ready(init); // Inicia a AI.
$(window).unload(uninit); // Encerra a AI.

/*
 * Inicia a Atividade Interativa (AI)
 */
function init () {
  preFetchHook();
  memento = fetch();
  postFetchHook(memento);
}

/*
 * Encerra a Atividade Interativa (AI)
 */ 
function uninit () {
  //commit(memento);
  //scorm.quit();
}

/*
 * Reinicia a AI: retorna tudo ao valor padrão (NÃO apaga a nota no LMS quando a atividade já estiver concluída) 
 */
function reset () {
	
  movie.reset();
  
  // NÃO ALTERA memento.completed!
  // NÃO ALTERA memento.score!
  // NÃO ALTERA memento.learner!
  
  setFrame(0);
}

/*
 * Inicia a conexão SCORM.
 */ 
function fetch () {
 
  var ans = {};
  ans.completed = false;
  ans.score = 0;
  ans.learner = "";
  ans.frame = 0;
  
  // Conecta-se ao LMS
  session.connected = scorm.init();
  session.standalone = !session.connected;
  
  // Se estiver rodando como stand-alone, usa local storage (HTML 5)
  if (session.standalone) {
  
      var stream = localStorage.getItem(LOCAL_STORAGE_KEY);
      //if (stream != null) ans = JSON.parse(stream);
  }
  // Se estiver conectado a um LMS, usa SCORM
  else {
  
    // Obtém o status da AI: concluída ou não.
    var completionstatus = scorm.get("cmi.completion_status");
    
    switch (completionstatus) {
    
      // Primeiro acesso à AI
      case "not attempted":
      case "unknown":
      default:
      	ans.learner = scorm.get("cmi.learner_name");
        break;
        
      // Continuando a AI...
      case "incomplete":
        var stream = scorm.get("cmi.location");
        if (stream != "") ans = JSON.parse(stream);
      	ans.learner = scorm.get("cmi.learner_name");
        break;
        
      // A AI já foi completada.
      case "completed":
        var stream = scorm.get("cmi.location");
        if (stream != "") ans = JSON.parse(stream);
      	ans.learner = scorm.get("cmi.learner_name");
        break;
    }    
  }
  
  return ans;
}

/*
 * Salva cmi.score.raw, cmi.location e cmi.completion_status no LMS (ou local storage, se não houver um LMS)
 */ 
function commit (data) {

  var success = false;
  
  // Se estiver rodando como stand-alone, usa local storage (HTML 5)
  if (session.standalone) {
	
    var stream = JSON.stringify(data);
    localStorage.setItem(LOCAL_STORAGE_KEY, stream);
    
    success = true;
  }
  // Se estiver conectado a um LMS, usa SCORM
  else {  

    if (session.connected) {
    
      // Salva no LMS a nota do aluno.
      success = scorm.set("cmi.score.raw", data.score);
      
      // Salva no LMS o status da atividade: completada ou não.
      success = scorm.set("cmi.completion_status", (data.completed ? "completed" : "incomplete"));
      
      // Salva no LMS os demais dados da atividade.
      var stream = JSON.stringify(data);      
      success = scorm.set("cmi.location", stream);
    }
  }
  
  return success;
}

// Tenta acessar os métodos expostos do filme Flash repetidas vezes, até funcionar ou até o limite de MAX_INIT_TRIES
function checkCallbacks () {
	var t2 = new Date().getTime();

	try {
		movie.doNothing();
		message("Callbacks disponíveis após " + ((t2 - t1)/ 1000) + " segundos.");

		// Recoloca no quadro correto  
		setFrame(memento.frame);

		// Oculta a mensagem "Configurando a atividade. Por favor, aguarde."
		$(".init-message").hide();
	}
	catch(error) {
		++init_tries;
		
		if (init_tries > MAX_INIT_TRIES) {
			// Exibe a mensagem de falha na configuração da AI.
			$(".init-message").hide();
			$("#init-failure-message").show();
		}
		else {
			setTimeout("checkCallbacks()", 1000);
			message("Callbacks NÃO disponíveis após " + ((t2 - t1) / 1000) + " segundos.");
		}
	}
}

// Mensagens de log
function message (m) {
	try {
		if (debug) console.log(m);
	}
	catch (error) {
		// Nada.
	}
}