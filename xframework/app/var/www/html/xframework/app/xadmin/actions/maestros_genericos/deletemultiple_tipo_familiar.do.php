<?php

  /** 	
   * 	Accion: Eliminacion mutiple
   *
   *
   */
  $manager = $this->getManager("ManagerTipoFamiliar");

  $manager->deleteMultiple($this->request['ids'], true);

  $this->finish($manager->getMsg());
