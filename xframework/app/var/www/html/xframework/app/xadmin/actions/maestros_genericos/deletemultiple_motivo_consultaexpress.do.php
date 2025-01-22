<?php

  /** 	
   * 	Accion: Eliminacion mutiple
   *
   *
   */
  $manager = $this->getManager("ManagerMotivoConsultaExpress");

  $manager->deleteMultiple($this->request['ids'], true);

  $this->finish($manager->getMsg());
