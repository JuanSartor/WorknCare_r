<?php
    /**
	*	
	*  Elimina el archivo asociado a un registro
	*
	*	@author Emanuel del Barco
	*
	*/	
    

    $this->start();    
	
    $manager_str = $this->request["manager"];
	$id = $this->request["id"];
	$name = $this->request["name"];
	
    $manager = $this->getManager($manager_str);
	
    //si existe el manager ordenamos
	if ($manager->deleteAttachedFile($id,$name)){			
    	$this->finish("[true]Eliminado con exito[true]");
	}else{
        $this->finish("[true]Error[true]");
    }

?>
