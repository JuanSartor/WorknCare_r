/******************************************************************************
 *
 *  Funciones de login 
 *
 ******************************************************************************/  

	/**
	* Calcula el sha1 en base64 y realiza el login
	*
	*
	*/
	var preLoginSHA1 = function(form,passwordId){  
            
        if (x_validateForm(form)){            
            $("#"+passwordId).val(Base64.encode(SHA1( $("#"+passwordId).val() )));
            x_sendForm(form,true,doLogin);
            $("#"+passwordId).val("");
        }
    
    }
    
    /**
     * doLogin
     *
     **/              
	var doLogin = function(json) {

        if (!json.result){
        
            x_assignMsgVars(json);
        
        }else if(json.result){
        
            window.location = controller+'.php?';
        
        }
	}

	
