<?php

 
  /**
   * Action para la eliminación 
   */
  $manager = $this->getManager("ManagerPerfilSaludEstudios");
  
  $result = $manager->delete($this->request["id"]);
  
  $this->finish($manager->getMsg());


