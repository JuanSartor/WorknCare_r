<?php
/**
 *  Realiza la baja de un registro.
 *
 */  
    
    
    $manager = $this->getManager("ManagerXSeo");
	
	$id = (int)$this->request['id'];

    $manager->delete($id,true);
    
    $this->finish($manager->getMsg());

?>
