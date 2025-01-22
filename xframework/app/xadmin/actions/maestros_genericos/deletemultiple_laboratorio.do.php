<?php

  /** 	
   * 	Accion: Eliminacion mutiple
   *
   *
   */
  $manager = $this->getManager("ManagerLaboratorio");

  $manager->deleteMultiple($this->request['ids'], true);

  $this->finish($manager->getMsg());
