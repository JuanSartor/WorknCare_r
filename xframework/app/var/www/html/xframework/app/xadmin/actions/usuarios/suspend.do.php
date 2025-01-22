<?php
/**
 *  Realiza la baja de un registro.
 *
 */  
    
    
    $manager = $this->getManager("ManagerPerfiles");
	
	$id = (int)$this->request['id'];

    $manager->suspend($id);
    
    $this->finish($manager->getMsg());

?>
