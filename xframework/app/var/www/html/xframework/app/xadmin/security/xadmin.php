<?php session_start();

    /**
     *  Validaa usuario logueado.
     *
     */            
	if (
        (!$_SESSION[URL_ROOT][CONTROLLER]["allowed"] || !isset($_SESSION[URL_ROOT][CONTROLLER]['logged_account'])) 
        ){
                                                    
        if (isset($_REQUEST['fromajax']) && $_REQUEST['fromajax'] == 1 ){
            if ( (!in_array($_REQUEST['modulo'], array("home","login"))) || (!in_array($_REQUEST['submodulo'], array("login","forgot","resetPass"))) )
                die("acceso no autorizado");
        }else{
           if ( (!in_array($_REQUEST['modulo'], array("home","login"))) || (!in_array($_REQUEST['submodulo'], array("login","forgot","resetPass"))) )
            header("Location: login.php");
           
           
        } 
	}
?>
