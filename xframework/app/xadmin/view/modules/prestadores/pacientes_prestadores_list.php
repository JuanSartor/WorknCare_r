<?php

  /**
   *  Pacientes Form
   *
   * */
  if (isset($this->request["idprestador"]) && (int) $this->request["idprestador"] > 0) {
      $manager = $this->getManager("ManagerPrestador");

      //con el flag active=0 obtenemos todos los pacientes activos e inactivos
      $record = $manager->get($this->request["idprestador"]);



      $this->assign("prestador", $record);

  } 

    
?>