<?php
    /**
	*	
	*   Nuevo/Editar
	*
	*	@author Emanuel del Barco
	*
	*/	

    $this->start();        
    $manager = $this->getManager("ManagerXSeo");
    $result = $manager->process($this->request);            
	$this->finish($manager->getMsg()); 
	
?>
