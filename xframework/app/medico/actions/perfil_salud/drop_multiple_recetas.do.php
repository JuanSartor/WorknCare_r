<?php

  
  /**
   * Action para la eliminación 
   */
  $manager = $this->getManager("ManagerPerfilSaludRecetaArchivo");
  
  $result = $manager->deleteMultiple($this->request["ids"]);
  
  $this->finish($manager->getMsg());


