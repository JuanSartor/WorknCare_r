<?php

  /**
   *  Usuarios prestador Form
   *
   * */
  if (isset($this->request["id"]) && (int) $this->request["id"] > 0) {
      $manager = $this->getManager("ManagerUsuarioPrestador");

      //con el flag active=0 obtenemos todos los pacientes activos e inactivos
      $record = $manager->get($this->request["id"]);



      $this->assign("record", $record);

  } 


?>