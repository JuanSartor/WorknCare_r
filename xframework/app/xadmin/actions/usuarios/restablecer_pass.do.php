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
    $result = $manager->setPassAleatoria($this->request["IdUsuario"]);            
	$this->finish($manager->getMsg()); 
	
?>
