<?php

  /** 	
   * 	Accion: Eliminacion simple >> Baja Lógica
   */
  $manager = $this->getManager("ManagerCirugiaOcular");

  $manager->delete($this->request['id'], true);

  $this->finish($manager->getMsg());
  