<?php

  /** 	
   * 	Accion: Eliminacion simple >> Baja Lógica
   */
  $manager = $this->getManager("ManagerVacunaEdad");

  $manager->delete($this->request['id'], false);

  $this->finish($manager->getMsg());