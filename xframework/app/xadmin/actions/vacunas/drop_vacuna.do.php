<?php

  /** 	
   * 	Accion: Eliminacion simple >> Baja Lógica
   */
  $manager = $this->getManager("ManagerVacuna");

  $manager->delete($this->request['id'], false);

  $this->finish($manager->getMsg());
  