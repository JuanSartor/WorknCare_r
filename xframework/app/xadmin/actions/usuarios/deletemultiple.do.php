<?php
/**
 *  Realiza la baja de multiples registros
 *
 */  

    $manager = $this->getManager("ManagerUsuarios");
	
    $manager->deleteMultiple($this->request['ids'], true);
    
    $this->finish($manager->getMsg());

?>
