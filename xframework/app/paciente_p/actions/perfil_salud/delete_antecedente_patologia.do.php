<?php

 
  /**
   * Action para la eliminación 
   */
  $manager = $this->getManager("ManagerAntecedentesPatologiaFamiliar");
  
  $result = $manager->delete($this->request["id"]);
  
  $this->finish($manager->getMsg());



