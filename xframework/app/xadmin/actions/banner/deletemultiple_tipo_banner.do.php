<?php

  /** 	
   * 	Accion: Eliminacion mutiple
   *
   *
   */
  $manager = $this->getManager("ManagerTipoBanner");

  $manager->deleteMultiple($this->request['ids'], true);

  $this->finish($manager->getMsg());
