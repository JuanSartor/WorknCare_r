<?php

  /** 	
   * 	Accion: Alta genérica de los pacientes
   * 	
   */
  $this->start();
  $manager = $this->getManager("ManagerUsuarioWeb");
//$manager->debug();
  $this->request["tipo_usuario"] = "paciente";
  $result = $manager->changePasswordAdmin($this->request);
  $this->finish($manager->getMsg());
  