<?php

  //Id del paciente que el médico elije
  $idpaciente = $this->request["id"];

  if ((int) $idpaciente > 0) {
      $ManagerPerfilSaludAdjunto = $this->getManager("ManagerPerfilSaludAdjunto");

      $listado = $ManagerPerfilSaludAdjunto->getListAdjuntoConsulta(array(
            "idpaciente" => $idpaciente,
            "idperfilSaludConsulta" => $this->request["idperfilSaludConsulta"])
      );
        
      if ($listado) {
          $this->assign("listado_adjuntos", $listado);
        
      }
  }
