<?php
    /**
	*	
	*  Puestos
	*
	*	@author Emanuel del Barco
	*
	*/	

    $manager = $this->getManager("ManagerUsuarios");

    $idpaginate = "usuarios_listado";
 
	$records = $manager->getUsuariosJSON($idpaginate,$this->request);	
	 
    echo $records;
    
	
?>
