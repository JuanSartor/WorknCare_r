<?php

  /**
   * Action de modificación / creación de las facturas del médico
   */
  $this->start();
  
  $manager = $this->getManager("ManagerMedico");
  
  $result = $manager->changeTipoPlan($this->request);
  
  $this->finish($manager->getMsg());
  