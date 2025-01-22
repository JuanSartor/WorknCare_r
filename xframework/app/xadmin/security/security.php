<?php session_start();

    /**
     *  Validaa usuario logueado.
     *
     */            
	if (
        (!$_SESSION[URL_ROOT]["autorizado"] || !isset($_SESSION[URL_ROOT]['username'])) 
        ){
                                                    
        if (isset($_REQUEST['fromajax']) && $_REQUEST['fromajax'] == 1 ){
            if ( (!in_array($_REQUEST['modulo'], array("home","login"))) || (!in_array($_REQUEST['submodulo'], array("login","forgot"))) )
                die("acceso no autorizado");
        }else{
           if ( (!in_array($_REQUEST['modulo'], array("home","login"))) || (!in_array($_REQUEST['submodulo'], array("login","forgot"))) )
            header("Location: ".CONTROLLER.".php?modulo=home&submodulo=login");
            //die("acceso no autorizado");
           
        } 
	}
?>
