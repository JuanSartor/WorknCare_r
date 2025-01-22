<?php

  /** 	
   * 	Accion: Eliminacion mutiple
   *
   *
   */
  $manager = $this->getManager("ManagerTipoPatologia");

  $manager->deleteMultiple($this->request['ids'], true);

  $this->finish($manager->getMsg());
