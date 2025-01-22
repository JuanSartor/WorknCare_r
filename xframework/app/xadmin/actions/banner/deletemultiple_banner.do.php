<?php

  /** 	
   * 	Accion: Eliminacion mutiple
   *
   *
   */
  $manager = $this->getManager("ManagerBanner");

  $manager->deleteMultiple($this->request['ids'], true);

  $this->finish($manager->getMsg());
