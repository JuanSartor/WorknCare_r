<?php

/**
 *  Upload comun para todos los modulos, mueve una imagen temporal
 *  temps/file.tmp o el temps/$hash.tmp 
 *  Guarda en una variable de session los datos de $_FILES['file_temp']   
 *
 */  
 //	require_once(path_managers("ManagerUpload.php"));
    
    //session_start();

	
    $front = (int)$_REQUEST['front'];
    
    /*if (!isset($_REQUEST['hash']) ){
       if ($front == 0){ 
            header("Location: common.php?modulo=upload&submodulo=image&fromajax=1&msg=bad");
        }else{
            header("Location: common.php?modulo=upload&submodulo=image_front&fromajax=1&msg=bad");
        }
    }*/
	

	
    $hash = $_REQUEST['hash'];

    
    $uploadData = $_SESSION[$hash];

    
    
    $todo =  $_REQUEST["todo"];
    
    $managerStr = $uploadData["manager"];

    //$data =  print_r($uploadData,true).print_r($_FILES,true);
    
    //file_put_contents(path_root("log_upload.txt"), $data);
    
    $manager = $this->getManager($managerStr);
    
   // $debug = "";
    
    if ($manager!= ""){
        
        
        switch ($todo) {
            case "add":case "modify":
                
                
               $result =  $manager->uploadImg($hash);
        	   
        	   $image = $_SESSION[$hash]["image"];
        	   
        	break;
    
            /*case "modify":
                            
                $result = $manager->uploadImg($hash);
                
                 if ($result>0){  
                                                     
                    $manager->modifyImg( $_SESSION[$hash]["image"] ,$uploadData["id"]);                                            
                    $result = 1;
                    $image = "files/".$manager->getMyImg($uploadData["id"]);
                }
                
                
                $_SESSION[$hash]["image"] = "files/".$manager->getMyImg($uploadData["id"]);            
               
        	
        	break;*/
        	
            case "delete":
                
                if ($manager->deleteImg($hash)){
                    $result = 2;
                }else{
                    $result = -3;
                }
        	
        	break;    

            case "delete_temp":
                
                if ($manager->deleteImgTemp($hash)){
                    $result = 2;
                }else{
                    $result = -3;
                }
        	
        	break; 
            	
        }    
    }else{
        $debug = "NO entro a manager \n";
    }

  /*  switch ($result) {
        case 1:
           //subido ok
            header("Location: common.php?modulo=upload&submodulo=$submod&hash=$hash&fromajax=1&msg=ok");
        break;
        case 2:
            //eliminado ok
            header("Location: common.php?modulo=upload&submodulo=$submod&hash=$hash&fromajax=1&msg=eliminado_ok");
        break;        
        case -1:
            //error al subir: tama�o superado
    	   header("Location: common.php?modulo=upload&submodulo=$submod&fromajax=1&hash=$hash&msg=bad_tamanio");
    	   break;
        case -2:
            //error al subir: tipo incorrecto
    	   header("Location: common.php?modulo=upload&submodulo=$submod&fromajax=1&hash=$hash&msg=bad_tipo");
    	   break;               	   
        case -3:
            //error al eliminar la imagen
    	   header("Location: common.php?modulo=upload&submodulo=$submod&fromajax=1&hash=$hash&msg=bad_tipo");
    	   break;      	   
    }*/
    
    switch ($result) {


        case 1:
        	$return = array(
        		'status' => '1',
        		'name' => $hash.'_'.$_FILES['Filedata']['name'],
        		'hash' => $hash,
        		'image'=>$image
        	);
        	break;  
        case 2:
        	$return = array(
        		'status' => '1',        		
        		'msg'=>"Enlevé avec succès"
        	);        	
    
        break;

        case -3:
        	$return = array(
        		'status' => '0',        		
        		'error' => "Le fichier n`a pas pu être supprimé"
        	);        	
    
        break;        
        
        default :
        
            $return = array(
        		'status' => '0',
        		'error' => "Erreur lors de l`envoi du fichier ($result) $debug "
        	);    
    
    }
    
    echo json_encode($return);

?>
