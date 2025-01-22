<?php
/**
 *  Actualiza la pass del user acutalk
 *  
 */  

 	// manager de usuarios
    $manager = $this->getManager("ManagerUsuarios");
    $manager->changePassword($this->getRequest()); 			  
    $this->finish($manager->getMsg());    


?>
