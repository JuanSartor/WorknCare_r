<?php

/**
 *  Sube una imagen para una galeria
 *  
 *     
 *
 */  
	


	
   /* $hash = $_REQUEST['hash'];

    
    $uploadData = $_SESSION[$hash];*/

    
    
    $id =  $this->request["id"];
    
    $managerStr = $this->request["manager"];
    
    $manager = $this->getManager($managerStr);
            
    /*$data =  print_r($this->request,true).print_r($_FILES,true);
    
    file_put_contents(path_root("log_upload.txt"), $data);*/
    
   // $debug = "";
    
    if ($manager!= ""){
                
        $result =  $manager->uploadImgGallery($id);

    }

    switch ($result) {


        case 1:
        	$return = array(
        		'status' => '1',
        		'name' => $_FILES['Filedata']['name']

        	);
        	break;  
      
        default :
        
            $return = array(
        		'status' => '0',
        		'error' => "Error al subir archivo ($result) $debug "
        	);    
    
    }
    
    echo json_encode($return);

?>
