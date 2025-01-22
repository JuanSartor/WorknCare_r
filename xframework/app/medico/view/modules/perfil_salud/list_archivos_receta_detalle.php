<?php

  //Id del paciente que el médico elije
  $idpaciente = $this->request["id"];

  if ((int) $idpaciente > 0) {
      $ManagerPerfilSaludReceta = $this->getManager("ManagerPerfilSaludReceta");

      $listado = $ManagerPerfilSaludReceta->getListRecetaConsulta(array(
            "idpaciente" => $idpaciente,
            "idperfilSaludConsulta" => $this->request["idperfilSaludConsulta"])
      );
   
      if ($listado) {
          $this->assign("listado_recetas", $listado);
         
      }
  }
