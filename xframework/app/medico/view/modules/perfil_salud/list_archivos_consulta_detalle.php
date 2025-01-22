<?php

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
