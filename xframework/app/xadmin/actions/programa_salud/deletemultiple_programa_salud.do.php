<?php

  /** 	
   * 	Accion: Eliminacion mutiple
   *
   *
   */
  $manager = $this->getManager("ManagerProgramaSalud");

  $manager->deleteMultiple($this->request['ids'], true);

  $this->finish($manager->getMsg());
