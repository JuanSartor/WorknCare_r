<?php
/**
 *  PROVIENE DE UN ENLACE EXTERNO, PARA RESET DE PASS
 */
  
    $manager = $this->getManager("ManagerXadminUsers");
    
    $reset = $manager->getResetForPassword($this->request);
    
    $this->assign("reset",$reset);

?>
