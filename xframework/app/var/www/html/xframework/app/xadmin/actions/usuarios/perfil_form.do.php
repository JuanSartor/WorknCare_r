<?php
/**
 *  Actualiza la pass del user acutalk
 *  
 */  

 	// manager de usuarios
    $manager = $this->getManager("ManagerUsuarios");
	$manager->guardarPerfil($this->getRequest()); 			
    $this->finish($manager->getMsg());    


?>
