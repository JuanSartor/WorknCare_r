<?php

  /** 	
   * 	Accion: Eliminacion mutiple
   *
   *
   */
  $manager = $this->getManager("ManagerMotivoVisita");

  $manager->deleteMultiple($this->request['ids'], true);

  $this->finish($manager->getMsg());
