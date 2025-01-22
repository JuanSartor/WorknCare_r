<?php

  
  /**
   * Action para la eliminación 
   */
  $manager = $this->getManager("ManagerPerfilSaludEstudios");
  
  $result = $manager->deleteMultiple($this->request["ids"]);
  
  $this->finish($manager->getMsg());


