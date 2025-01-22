<?php
/**
 *  USUARIOS
 * 
 **/
  
    $manager = $this->getManager("ManagerUsuarios");

    $usuario = $manager->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']['id']);
    
    $this->assign("user",$usuario);

?>
