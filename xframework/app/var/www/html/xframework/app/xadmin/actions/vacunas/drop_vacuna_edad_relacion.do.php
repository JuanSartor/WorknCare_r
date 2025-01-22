<?php

  /** 	
   * 	Accion: Eliminacion simple >> Baja Lógica
   */
  $manager = $this->getManager("ManagerVacunaVacunaEdad");

  $manager->delete($this->request['id'], false);

  $this->finish($manager->getMsg());