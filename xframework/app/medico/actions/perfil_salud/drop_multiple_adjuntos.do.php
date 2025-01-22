<?php

  
  /**
   * Action para la eliminación 
   */
  $manager = $this->getManager("ManagerPerfilSaludAdjuntoArchivo");
  
  $result = $manager->deleteMultiple($this->request["ids"]);
  
  $this->finish($manager->getMsg());


