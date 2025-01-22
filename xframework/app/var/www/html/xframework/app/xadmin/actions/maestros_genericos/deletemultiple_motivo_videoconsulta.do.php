<?php

  /** 	
   * 	Accion: Eliminacion mutiple
   *
   *
   */
  $manager = $this->getManager("ManagerMotivoVideoConsulta");

  $manager->deleteMultiple($this->request['ids'], true);

  $this->finish($manager->getMsg());
