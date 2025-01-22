<?php

  /** 	
   * 	Accion: Eliminacion mutiple
   *
   *
   */
  $manager = $this->getManager("ManagerTituloProfesional");

  $manager->deleteMultiple($this->request['ids'], true);

  $this->finish($manager->getMsg());
