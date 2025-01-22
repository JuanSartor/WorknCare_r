<?php

  /**
   * Action para la eliminación 
   */
  $manager = $this->getManager("ManagerPerfilSaludCirugias");
  
  $result = $manager->delete($this->request["id"]);
  
  $this->finish($manager->getMsg());

