<?php
/*
Los helpers seran archivos php que serviran para el JS interactúe con estos de alguna manera.

*/

/* TODO: implementar file_exists.php en este archivo y que reciba los parametros necesarios. 

 El parametro request es obligatorio e indica la funcion a ejecutar.

en el arcvhivo x_ajax tenemos esto:

x_doAjaxCall("get","core/helpers/filesystem.php?request=file_exist&file="+submodulo,'','loadJs','',"doError", true) ;

*/
    session_start();
        
    $action = $_REQUEST['request'];
    
    switch ($action) {
        //archivo javascript asociado a un template.
        case "javascript_exist":
            
            $myController = $_REQUEST["controller"];         		      
    	   	
               
            $file = path_app("$myController/view/templates/".$_REQUEST["module"]."/".$_REQUEST["submodule"].".js");                        
                                
        	// Verificamos si hay un JS para cargar con el nombre del submodulo
        	if (file_exists($file))  {
                $fileURL = url_app("$myController/view/templates/".$_REQUEST["module"]."/".$_REQUEST["submodule"].".js");
        		die("$fileURL");
    
        	} else {
    
        		die();
    
        	}
    	   
    	
    	break;
    }//fin switch case



?>
