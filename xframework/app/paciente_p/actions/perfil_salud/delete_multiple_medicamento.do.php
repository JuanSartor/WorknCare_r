<?php
  
  /**
   * Action para la eliminación 
   */
  $manager = $this->getManager("ManagerPerfilSaludMedicamento");
  
  $result = $manager->deleteMultiple($this->request["ids"]);
  
  $this->finish($manager->getMsg());

