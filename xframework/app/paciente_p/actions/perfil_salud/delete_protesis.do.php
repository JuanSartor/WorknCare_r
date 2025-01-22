<?php
  
  /**
   * Action para la eliminación 
   */
  $manager = $this->getManager("ManagerPerfilSaludProtesis");
  
  $result = $manager->delete($this->request["id"]);
  
  $this->finish($manager->getMsg());

