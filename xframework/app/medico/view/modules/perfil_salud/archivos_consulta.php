<?php

  /*
   * To change this license header, choose License Headers in Project Properties.
   * To change this template file, choose Tools | Templates
   * and open the template in the editor.
   */
  //Id del paciente que el médico elije
    $idpaciente = $this->request["id"];

  if ((int) $idpaciente > 0) {
      $ManagerPerfilSaludEstudios = $this->getManager("ManagerPerfilSaludEstudios");
      
      $listado = $ManagerPerfilSaludEstudios->getListEstudiosConsulta(array(
            "idpaciente" => $idpaciente,
            "idperfilSaludConsulta" => $this->request["idperfilSaludConsulta"])
      );
      if ($listado) {
          $this->assign("listado_imagenes", $listado);
      }
  }