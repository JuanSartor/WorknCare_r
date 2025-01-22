<?php

  /** 	
   * 	Accion: Eliminacion mutiple
   *
   *
   */
  $manager = $this->getManager("ManagerMedicamento");

  $manager->deleteMultiple($this->request['ids'], true);

  $this->finish($manager->getMsg());
