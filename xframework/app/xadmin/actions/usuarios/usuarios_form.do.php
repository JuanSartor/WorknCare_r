<?php
    /**
	*	
	*  Nuevo/Editar
	*
	*	@author Emanuel del Barco
	*
	*/	

    $this->start();        
    $manager = $this->getManager("ManagerUsuarios");
    $result = $manager->process($this->request);            
	$this->finish($manager->getMsg()); 
	
?>
