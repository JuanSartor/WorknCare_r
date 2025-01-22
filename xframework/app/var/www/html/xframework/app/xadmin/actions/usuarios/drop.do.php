<?php
/**
 *  Realiza la baja de un registro.
 *
 */  
    
    
    $manager = $this->getManager("ManagerUsuarios");
	
	$id = (int)$this->request['id'];

    $manager->delete($id,false);
    
    $this->finish($manager->getMsg());

?>
