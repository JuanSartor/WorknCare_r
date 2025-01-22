<?php

/**
 *  Upload comun para todos los modulos, mueve un archivo temporal
 *  temps/file.tmp o el temps/$_REQUEST['name'].tmp 
 *  Guarda en una variable de session los datos de $_FILES['file_temp']   
 *
 */  	

    
    if (!isset($_REQUEST['hash']) ){   
       header("Location: common.php?modulo=upload&submodulo=upload&fromajax=1&msg=bad");
    }
	
    $hash = $_REQUEST['hash'];
    
    $uploadData = $_SESSION[$hash];
    
    $manager = new Uploader($hash, $uploadData['max_size'], $uploadData['type']);
    

    $todo =  $_REQUEST["todo"];
    
    
    switch ($todo) {
        case "add":case "modify":
            
            if ($uploadData["name"]!=""){
                $name = $uploadData["name"];
            }else{
                $name = $hash;
            }        
            $path = path_files("temp/$name");
            $result = $manager->moveTo($path);
            
            if ($result>0){
                $_SESSION[$hash]["realName"] = $manager->getFileName();
            }
    	
    	break;
    	
        case "delete":
                                   
            $managerStr = $uploadData["manager"];
            
            $managerX = $this->getManager($managerStr);

            $id = $uploadData["id"];
            $name = $uploadData["name"];
            
            if ($managerX->deleteFile($id,$name)){
                $result = 2;
            }else{
                $result = -3;
            }
    	
    	break;   

        case "delete_temp":

            if ($uploadData["name"]!=""){
                $name = $uploadData["name"];
            }else{
                $name = "file";
            }        
            
            $path = path_files("temp/$name");        
            
            if (unlink($path)){
                $result = 2;
            }else{
                $result = -3;
            }
    	
    	break;          	
    }  

    
    
    //se mueve el archivo
   

    switch ($result) {
        case 1:
        	$return = array(
        		'status' => '1',
        		'name' => $hash.'_'.$_FILES['Filedata']['name'],
        		'hash' => $hash
        	);
        	break;  
        case 2:
        	$return = array(
        		'status' => '1',        		
        		'msg'=>"Enlevé avec succès"
        	);        	
    
        break;
        case -1:
        	$return = array(
        		'status' => '0',        		
        		'error' => "Le fichier dépasse la taille autorisée (Taille limitée à 8 MB.)"
        	);        	
    
        break;        
        case -2:
        	$return = array(
        		'status' => '0',        		
        		'error' => "Type de fichier incorrect"
        	);        	
    
        break;   

        case -3:
        	$return = array(
        		'status' => '0',        		
        		'error' => "Le fichier na pas pu être supprimé"
        	);        	
    
        break;        
        
        default :
        
            $return = array(
        		'status' => '0',
        		'error' => "Erreur lors de l`envoi du fichier($result) "
        	); 
       
    }
    
    echo json_encode($return);    
?>
